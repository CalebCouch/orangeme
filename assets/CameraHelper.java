package com.orangeme.camera;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.ImageFormat;
import android.hardware.camera2.*;
import android.hardware.camera2.params.OutputConfiguration;
import android.hardware.camera2.params.SessionConfiguration;
import android.hardware.camera2.params.StreamConfigurationMap;
import android.media.Image;
import android.media.ImageReader;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.util.Log;
import android.util.Size;
import android.view.Surface;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.atomic.AtomicInteger;

public class CameraHelper {
    private static final String TAG = "CameraHelper";
    private static final int CAMERA_PERMISSION_REQUEST_CODE = 1001;
    private static final int SESSION_TIMEOUT_MS = 15000; 
    private static final int MAX_IMAGES = 5; 

    private static class ImageWrapper {
        private final Image image;
        private final AtomicInteger refCount = new AtomicInteger(1);
        private volatile boolean closed = false;

        public ImageWrapper(Image image) {
            this.image = image;
        }

        public Image getImage() {
            return image;
        }

        public boolean acquire() {
            int count;
            do {
                count = refCount.get();
                if (count <= 0 || closed) {
                    return false; 
                }
            } while (!refCount.compareAndSet(count, count + 1));
            
            if (closed || image == null) {
                release(); 
                return false;
            }
            
            return true;
        }

        public void release() {
            int count = refCount.decrementAndGet();
            if (count == 0 && !closed) {
                closed = true;
                try {
                    if (image != null) {
                        image.close();
                        Log.v(TAG, "Image closed by reference counting");
                    }
                } catch (Exception e) {
                    Log.w(TAG, "Error closing image in wrapper", e);
                }
            } else if (count < 0) {
                Log.w(TAG, "ImageWrapper reference count went negative: " + count);
            }
        }

        public boolean isClosed() {
            return closed || refCount.get() <= 0;
        }
        
        // ADDED: Method to check if image is still valid
        public boolean isImageValid() {
            if (closed || image == null) {
                return false;
            }
            try {
                // Test image validity by accessing a property
                image.getFormat();
                return true;
            } catch (IllegalStateException e) {
                Log.v(TAG, "Image in wrapper is no longer valid");
                return false;
            } catch (Exception e) {
                Log.w(TAG, "Unexpected error checking image validity", e);
                return false;
            }
        }
    }

    public interface CameraSessionCallback {
        void onSessionReady();
        void onSessionFailed(String error);
    }

    public interface PermissionCallback {
        void onPermissionGranted();
        void onPermissionDenied();
    }

    private final Context context;
    private final CameraManager cameraManager;
    private CameraDevice cameraDevice;
    private ImageReader imageReader;
    private CameraCaptureSession captureSession;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private final Executor mainExecutor;
    
    // Background thread for camera operations
    private HandlerThread backgroundThread;
    private Handler backgroundHandler;
    
    // FIXED: Thread-safe frame buffering with reference counting
    private final AtomicReference<ImageWrapper> latestImageWrapper = new AtomicReference<>(null);
    private final Object imageLock = new Object();
    
    private volatile boolean sessionReady = false;
    private volatile boolean cameraOpening = false;
    private volatile boolean waitingForPermission = false;
    private volatile boolean sessionConfiguring = false;
    
    private CameraSessionCallback sessionCallback;
    private PermissionCallback permissionCallback;
    private String pendingCameraId;
    
    // Session timeout handling
    private Runnable sessionTimeoutRunnable;

    public CameraHelper(Context context) {
        this.context = context;
        this.cameraManager = (CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
        this.mainExecutor = command -> mainHandler.post(command);
        startBackgroundThread();
    }

    private void startBackgroundThread() {
        backgroundThread = new HandlerThread("CameraBackground");
        backgroundThread.start();
        backgroundHandler = new Handler(backgroundThread.getLooper());
    }

    private void stopBackgroundThread() {
        if (backgroundThread != null) {
            backgroundThread.quitSafely();
            try {
                backgroundThread.join();
                backgroundThread = null;
                backgroundHandler = null;
            } catch (InterruptedException e) {
                Log.e(TAG, "Error stopping background thread", e);
            }
        }
    }

    public void setSessionCallback(CameraSessionCallback callback) {
        this.sessionCallback = callback;
    }

    public void setPermissionCallback(PermissionCallback callback) {
        this.permissionCallback = callback;
    }

    public boolean hasCameraPermission() {
        return context.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;
    }

    public boolean shouldShowRequestPermissionRationale() {
        if (!(context instanceof Activity)) return false;
        return ((Activity) context).shouldShowRequestPermissionRationale(Manifest.permission.CAMERA);
    }

    public void requestCameraPermission() {
        if (!(context instanceof Activity)) {
            throw new IllegalStateException("Context must be an Activity to request permissions");
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Log.d(TAG, "Requesting camera permission...");
            waitingForPermission = true;
            ((Activity) context).requestPermissions(
                new String[]{Manifest.permission.CAMERA},
                CAMERA_PERMISSION_REQUEST_CODE
            );
        }
    }

    // FIXED: Safe frame acquisition with proper reference counting and validation
    public Image acquireLatestImage() {
        if (imageReader == null) {
            Log.w(TAG, "ImageReader is null, cannot acquire image");
            return null;
        }
        
        synchronized (imageLock) {
            ImageWrapper wrapper = latestImageWrapper.get();
            if (wrapper != null && wrapper.acquire()) {
                Image image = wrapper.getImage();
                if (image != null && !wrapper.isClosed()) {
                    // CRITICAL FIX: Validate image before accessing properties
                    try {
                        // Test if image is still valid by accessing a property safely
                        int width = image.getWidth();
                        int height = image.getHeight();
                        Log.v(TAG, "Successfully retrieved cached image: " + width + "x" + height);
                        return image;
                    } catch (IllegalStateException e) {
                        Log.w(TAG, "Cached image is already closed, releasing wrapper", e);
                        wrapper.release(); // Release the invalid image
                        // Continue to fallback below
                    } catch (Exception e) {
                        Log.w(TAG, "Error accessing cached image properties", e);
                        wrapper.release(); // Release on any error
                        // Continue to fallback below
                    }
                } else {
                    if (wrapper.isClosed()) {
                        Log.v(TAG, "Wrapper is already closed");
                    } else {
                        Log.v(TAG, "Image in wrapper is null");
                    }
                    wrapper.release(); // Release if image is null or wrapper is closed
                }
            }
        }
        
        // Fallback - try to acquire directly from ImageReader
        try {
            Image image = imageReader.acquireLatestImage();
            if (image != null) {
                // CRITICAL FIX: Validate direct image before accessing properties
                try {
                    int width = image.getWidth();
                    int height = image.getHeight();
                    Log.d(TAG, "Successfully acquired image directly: " + width + "x" + height);
                    return image;
                } catch (IllegalStateException e) {
                    Log.w(TAG, "Directly acquired image is already closed", e);
                    try {
                        image.close(); // Try to close it properly
                    } catch (Exception closeException) {
                        Log.w(TAG, "Error closing invalid direct image", closeException);
                    }
                    return null;
                } catch (Exception e) {
                    Log.w(TAG, "Error accessing direct image properties", e);
                    try {
                        image.close(); // Try to close it properly
                    } catch (Exception closeException) {
                        Log.w(TAG, "Error closing direct image after property access error", closeException);
                    }
                    return null;
                }
            } else {
                Log.v(TAG, "No image available in ImageReader");
                return null;
            }
        } catch (Exception e) {
            Log.e(TAG, "Error acquiring latest image from ImageReader", e);
            return null;
        }
    }

    // CRITICAL: Call this when you're done with an image obtained from acquireLatestImage()
    public void releaseImage(Image image) {
        if (image == null) return;
        
        synchronized (imageLock) {
            ImageWrapper wrapper = latestImageWrapper.get();
            if (wrapper != null && wrapper.getImage() == image) {
                wrapper.release();
                return;
            }
        }
        
        // If it's not our cached image, it might be directly acquired - close it
        try {
            image.close();
            Log.v(TAG, "Released directly acquired image");
        } catch (Exception e) {
            Log.w(TAG, "Error releasing image", e);
        }
    }

    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        Log.d(TAG, "onRequestPermissionsResult called - requestCode: " + requestCode +
              ", permissions: " + Arrays.toString(permissions) +
              ", grantResults: " + Arrays.toString(grantResults));

        waitingForPermission = false;

        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE &&
            permissions.length > 0 &&
            Manifest.permission.CAMERA.equals(permissions[0])) {

            boolean granted = grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;
            Log.d(TAG, "Camera permission " + (granted ? "granted" : "denied"));

            if (permissionCallback != null) {
                if (granted) {
                    permissionCallback.onPermissionGranted();
                    if (pendingCameraId != null) {
                        Log.d(TAG, "Retrying camera open with pending ID: " + pendingCameraId);
                        String cameraId = pendingCameraId;
                        pendingCameraId = null;
                        mainHandler.post(() -> openCamera(cameraId));
                    }
                } else {
                    permissionCallback.onPermissionDenied();
                    pendingCameraId = null;
                    if (sessionCallback != null) {
                        sessionCallback.onSessionFailed("Camera permission denied");
                    }
                }
            } else {
                if (granted && pendingCameraId != null) {
                    Log.d(TAG, "Retrying camera open without callback - pending ID: " + pendingCameraId);
                    String cameraId = pendingCameraId;
                    pendingCameraId = null;
                    mainHandler.post(() -> openCamera(cameraId));
                } else if (!granted) {
                    pendingCameraId = null;
                    if (sessionCallback != null) {
                        sessionCallback.onSessionFailed("Camera permission denied");
                    }
                }
            }
        }
    }

    private void startSessionTimeout() {
        cancelSessionTimeout();
        sessionTimeoutRunnable = () -> {
            Log.e(TAG, "Session configuration timeout reached");
            if (sessionConfiguring) {
                sessionConfiguring = false;
                cleanup();
                if (sessionCallback != null) {
                    sessionCallback.onSessionFailed("Session configuration timeout");
                }
            }
        };
        mainHandler.postDelayed(sessionTimeoutRunnable, SESSION_TIMEOUT_MS);
    }

    private void cancelSessionTimeout() {
        if (sessionTimeoutRunnable != null) {
            mainHandler.removeCallbacks(sessionTimeoutRunnable);
            sessionTimeoutRunnable = null;
        }
    }

    private final CameraDevice.StateCallback cameraStateCallback = new CameraDevice.StateCallback() {
        @Override
        public void onOpened(CameraDevice camera) {
            Log.d(TAG, "Camera opened successfully");

            if (!hasCameraPermission()) {
                Log.w(TAG, "Camera permission revoked after opening, closing camera");
                camera.close();
                cameraOpening = false;
                if (sessionCallback != null) {
                    sessionCallback.onSessionFailed("Camera permission revoked");
                }
                return;
            }

            cameraDevice = camera;
            cameraOpening = false;
            
            // Start session creation immediately on background thread
            backgroundHandler.post(() -> {
                if (hasCameraPermission() && cameraDevice != null) {
                    Log.d(TAG, "Starting capture session on background thread");
                    startCaptureSession();
                } else {
                    Log.w(TAG, "Permission lost or camera closed, aborting session start");
                    mainHandler.post(() -> {
                        cleanup();
                        if (sessionCallback != null) {
                            sessionCallback.onSessionFailed("Permission lost or camera unavailable");
                        }
                    });
                }
            });
        }

        @Override
        public void onDisconnected(CameraDevice camera) {
            Log.w(TAG, "Camera disconnected");
            cleanup();
            if (sessionCallback != null) {
                sessionCallback.onSessionFailed("Camera disconnected");
            }
        }

        @Override
        public void onError(CameraDevice camera, int error) {
            Log.e(TAG, "Camera error: " + error);
            cleanup();
            if (sessionCallback != null) {
                sessionCallback.onSessionFailed("Camera error: " + error);
            }
        }
    };

    public void openCamera(String cameraId) {
        Log.d(TAG, "openCamera called with ID: " + cameraId);

        if (cameraOpening) {
            Log.w(TAG, "Camera is already opening");
            return;
        }

        if (cameraDevice != null) {
            Log.d(TAG, "Closing existing camera before opening new one");
            closeCamera();
        }

        if (!hasCameraPermission()) {
            Log.w(TAG, "Camera permission not granted, requesting permission. Storing pending camera ID: " + cameraId);
            pendingCameraId = cameraId;
            requestCameraPermission();
            return;
        }

        try {
            Log.d(TAG, "Opening camera: " + cameraId);
            cameraOpening = true;
            sessionReady = false;
            sessionConfiguring = false;
            pendingCameraId = null;
            cameraManager.openCamera(cameraId, cameraStateCallback, backgroundHandler);
        } catch (CameraAccessException | SecurityException e) {
            Log.e(TAG, "Failed to open camera", e);
            cameraOpening = false;
            pendingCameraId = null;
            if (sessionCallback != null) {
                sessionCallback.onSessionFailed("Failed to open camera: " + e.getMessage());
            }
        }
    }

    private void startCaptureSession() {
        if (cameraDevice == null) {
            Log.e(TAG, "Camera device is null when starting capture session");
            mainHandler.post(() -> {
                if (sessionCallback != null) {
                    sessionCallback.onSessionFailed("Camera device is null");
                }
            });
            return;
        }

        if (!hasCameraPermission()) {
            Log.e(TAG, "Camera permission lost during session creation");
            mainHandler.post(() -> {
                closeCamera();
                if (sessionCallback != null) {
                    sessionCallback.onSessionFailed("Camera permission lost");
                }
            });
            return;
        }

        try {
            Log.d(TAG, "Starting capture session");
            sessionConfiguring = true;
            startSessionTimeout();
            
            CameraCharacteristics characteristics = cameraManager.getCameraCharacteristics(cameraDevice.getId());
            StreamConfigurationMap map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP);

            if (map == null) {
                Log.e(TAG, "StreamConfigurationMap is null");
                sessionConfiguring = false;
                cancelSessionTimeout();
                mainHandler.post(() -> {
                    if (sessionCallback != null) {
                        sessionCallback.onSessionFailed("Camera configuration not available");
                    }
                });
                return;
            }

            Size[] sizes = map.getOutputSizes(ImageFormat.YUV_420_888);
            // Use smaller resolution for faster processing
            int width = 640;
            int height = 480;

            if (sizes != null && sizes.length > 0) {
                Log.d(TAG, "Available sizes: " + Arrays.toString(sizes));
                // Find a smaller suitable size for better performance
                for (Size size : sizes) {
                    if (size.getWidth() <= 640 && size.getHeight() <= 480) {
                        width = size.getWidth();
                        height = size.getHeight();
                        break;
                    }
                }
                // If no small size found, use the smallest available
                if (width == 640 && height == 480) {
                    Size smallest = sizes[sizes.length - 1];
                    for (Size size : sizes) {
                        if (size.getWidth() * size.getHeight() < smallest.getWidth() * smallest.getHeight()) {
                            smallest = size;
                        }
                    }
                    width = smallest.getWidth();
                    height = smallest.getHeight();
                }
                Log.d(TAG, "Selected camera resolution: " + width + "x" + height);
            } else {
                Log.w(TAG, "No YUV_420_888 sizes available, using default");
            }

            closeImageReader();

            // Increase buffer size for better frame availability
            imageReader = ImageReader.newInstance(width, height, ImageFormat.YUV_420_888, MAX_IMAGES);

            // ENHANCED: Proper image buffering with validation
            ImageReader.OnImageAvailableListener imageListener = reader -> {
                Image newImage = null;
                try {
                    newImage = reader.acquireLatestImage();
                    if (newImage != null) {
                        try {
                            newImage.getFormat();
                            newImage.getWidth();
                            
                            synchronized (imageLock) {
                            
                                ImageWrapper newWrapper = new ImageWrapper(newImage);
                                
                                ImageWrapper oldWrapper = latestImageWrapper.getAndSet(newWrapper);
                                if (oldWrapper != null) {
                                    oldWrapper.release();
                                }
                            }
                            Log.v(TAG, "New image cached: " + newImage.getWidth() + "x" + newImage.getHeight());
                            
                            newImage = null;
                            
                        } catch (IllegalStateException e) {
                            Log.w(TAG, "Acquired image is already invalid", e);
                         
                        } catch (Exception e) {
                            Log.w(TAG, "Error validating acquired image", e);
                        }
                    }
                } catch (Exception e) {
                    Log.w(TAG, "Error acquiring image from reader", e);
                } finally {
                    if (newImage != null) {
                        try {
                            newImage.close();
                        } catch (Exception e) {
                            Log.w(TAG, "Error closing unused image", e);
                        }
                    }
                }
            };

            imageReader.setOnImageAvailableListener(imageListener, backgroundHandler);

            createCaptureSessionCompat();

        } catch (CameraAccessException e) {
            Log.e(TAG, "Exception in startCaptureSession", e);
            sessionConfiguring = false;
            cancelSessionTimeout();
            mainHandler.post(() -> {
                if (sessionCallback != null) {
                    sessionCallback.onSessionFailed("Exception in startCaptureSession: " + e.getMessage());
                }
            });
        }
    }

    private void createCaptureSessionCompat() throws CameraAccessException {
        Log.d(TAG, "Creating capture session");
        
        List<Surface> surfaces = new ArrayList<>();
        surfaces.add(imageReader.getSurface());

        CameraCaptureSession.StateCallback stateCallback = new CameraCaptureSession.StateCallback() {
            @Override
            public void onConfigured(CameraCaptureSession session) {
                Log.d(TAG, "Capture session configured successfully");
                
                cancelSessionTimeout();
                sessionConfiguring = false;

                if (!hasCameraPermission() || cameraDevice == null) {
                    Log.w(TAG, "Permission lost or camera closed during session configuration");
                    session.close();
                    mainHandler.post(() -> {
                        if (sessionCallback != null) {
                            sessionCallback.onSessionFailed("Permission lost during session setup");
                        }
                    });
                    return;
                }

                captureSession = session;
                sessionReady = true;
                
                mainHandler.post(() -> {
                    if (sessionCallback != null) {
                        sessionCallback.onSessionReady();
                    }
                });
                
                startRepeatingCapture();
            }

            @Override
            public void onConfigureFailed(CameraCaptureSession session) {
                Log.e(TAG, "Failed to configure capture session");
                cancelSessionTimeout();
                sessionConfiguring = false;
                sessionReady = false;
                
                mainHandler.post(() -> {
                    if (sessionCallback != null) {
                        sessionCallback.onSessionFailed("Failed to configure session");
                    }
                });
            }

            @Override
            public void onClosed(CameraCaptureSession session) {
                Log.d(TAG, "Capture session closed");
                sessionReady = false;
            }
        };

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            
            try {
                List<OutputConfiguration> outputConfigs = new ArrayList<>();
                outputConfigs.add(new OutputConfiguration(imageReader.getSurface()));

                SessionConfiguration sessionConfig = new SessionConfiguration(
                    SessionConfiguration.SESSION_REGULAR,
                    outputConfigs,
                    backgroundHandler::post,
                    stateCallback);

                cameraDevice.createCaptureSession(sessionConfig);
                Log.d(TAG, "Using modern SessionConfiguration API");
            } catch (Exception e) {
                Log.w(TAG, "Modern API failed, falling back to legacy: " + e.getMessage());
         
                cameraDevice.createCaptureSession(surfaces, stateCallback, backgroundHandler);
            }
        } else {
            cameraDevice.createCaptureSession(surfaces, stateCallback, backgroundHandler);
            Log.d(TAG, "Using legacy createCaptureSession API");
        }
    }

    private void startRepeatingCapture() {
        if (captureSession == null || cameraDevice == null) {
            Log.w(TAG, "Cannot start repeating capture - session or device is null");
            return;
        }

        try {
            Log.d(TAG, "Starting repeating capture request");
            CaptureRequest.Builder requestBuilder = cameraDevice.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW);
            requestBuilder.addTarget(imageReader.getSurface());
            
            requestBuilder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE);
            requestBuilder.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON);
            
            requestBuilder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, new android.util.Range<>(30, 30));
            
            CaptureRequest captureRequest = requestBuilder.build();
            
            captureSession.setRepeatingRequest(captureRequest, null, backgroundHandler);
            Log.d(TAG, "Repeating capture request started successfully");
            
        } catch (CameraAccessException e) {
            Log.e(TAG, "Failed to start repeating capture", e);
        }
    }

    private void cleanup() {
        Log.d(TAG, "Cleaning up camera resources");
        cancelSessionTimeout();
        sessionReady = false;
        sessionConfiguring = false;
        cameraOpening = false;
        waitingForPermission = false;
        pendingCameraId = null;
        
        // Clean up cached image wrapper
        synchronized (imageLock) {
            ImageWrapper oldWrapper = latestImageWrapper.getAndSet(null);
            if (oldWrapper != null) {
                oldWrapper.release();
            }
        }
        
        closeCaptureSession();
        closeImageReader();
        
        if (cameraDevice != null) {
            cameraDevice.close();
            cameraDevice = null;
        }
    }

    private void closeImageReader() {
        if (imageReader != null) {
            Log.d(TAG, "Closing ImageReader");
            imageReader.close();
            imageReader = null;
        }
    }

    private void closeCaptureSession() {
        if (captureSession != null) {
            Log.d(TAG, "Closing CaptureSession");
            captureSession.close();
            captureSession = null;
        }
    }

    public void closeCamera() {
        Log.d(TAG, "Closing camera");
        cleanup();
    }

    public void release() {
        Log.d(TAG, "Releasing CameraHelper");
        closeCamera();
        stopBackgroundThread();
    }

    public boolean isSessionReady() {
        return sessionReady && cameraDevice != null && hasCameraPermission();
    }

    public boolean isWaitingForPermission() {
        return waitingForPermission;
    }

    public boolean isCameraOpening() {
        return cameraOpening;
    }

    public boolean isSessionConfiguring() {
        return sessionConfiguring;
    }

    public CameraDevice getCameraDevice() {
        return cameraDevice;
    }

    public CameraManager getCameraManager() {
        return cameraManager;
    }

    public ImageReader getImageReader() {
        return imageReader;
    }

    public CameraCaptureSession getCaptureSession() {
        return captureSession;
    }

    public String[] getCameraIdList() {
        try {
            return cameraManager.getCameraIdList();
        } catch (CameraAccessException e) {
            Log.e(TAG, "Failed to get camera ID list", e);
            return new String[0];
        }
    }
}
