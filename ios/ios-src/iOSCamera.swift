#if os(iOS)

import Foundation
import AVFoundation
import UIKit

// Public enum for Camera Errors
public enum CameraError: Error {
    case accessDenied
    case restricted
    case waitingForAccess
    case unknown
}

// Global variables to hold camera frame and status
var latestFramePtr: UnsafeMutableRawPointer?
var latestFrameSize: Int = 0
var latestPixelBuffer: CVPixelBuffer?
var cameraCaptureInstance: CameraCapture?

// CameraCapture class for macOS using AVFoundation
public class CameraCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    
    // Declare cameraAccessStatus as an internal member of CameraCapture
    private(set) public var cameraAccessStatus: AVAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        setupCamera()
    }

    // Setup the camera for capture
    public func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            print("Failed to initialize camera.")
            return
        }

        session.beginConfiguration()
        session.sessionPreset = .medium

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraQueue"))

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
        session.startRunning()
    }

    // Delegate method to process camera frames
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            return
        }

        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let size = bytesPerRow * height

        // Update the global pointer if needed
        if latestFramePtr == nil || latestFrameSize != size {
            if let ptr = latestFramePtr {
                free(ptr)
            }
            latestFramePtr = malloc(size)
            latestFrameSize = size
        }

        memcpy(latestFramePtr, baseAddress, size)
        latestPixelBuffer = pixelBuffer
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
    }

    // MARK: - Permission Handling
    public func checkCameraAccess() -> Result<String, CameraError> {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .success("Camera view enabled")
        case .denied:
            return .failure(.accessDenied)
        case .restricted:
            return .failure(.restricted)
        case .notDetermined:
            return .failure(.waitingForAccess)
        @unknown default:
            return .failure(.unknown)
        }
    }

    // Request camera access and update status
    public func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { response in
            DispatchQueue.main.async {
                self.cameraAccessStatus = AVCaptureDevice.authorizationStatus(for: .video)
            }
        }
    }
}

// C Exports for Rust
@_cdecl("start_camera_capture")
public func start_camera_capture() {
    DispatchQueue.main.async {
        if cameraCaptureInstance == nil {
            cameraCaptureInstance = CameraCapture()
            print("Camera started")
        }
    }
}

@_cdecl("get_latest_frame")
public func get_latest_frame() -> UnsafeMutableRawPointer? {
    return latestFramePtr
}

@_cdecl("get_latest_frame_size")
public func get_latest_frame_size() -> Int {
    return latestFrameSize
}

@_cdecl("get_latest_frame_stride")
public func get_latest_frame_stride() -> Int {
    guard let pixelBuffer = latestPixelBuffer else { return 0 }
    return CVPixelBufferGetBytesPerRow(pixelBuffer)
}

@_cdecl("check_camera_access")
public func check_camera_access() -> UnsafePointer<CChar>? {
    let result: Result<String, CameraError> = cameraCaptureInstance?.checkCameraAccess() ?? .failure(.unknown)
    
    switch result {
    case .success(let successMessage):
        let cString = strdup(successMessage) // Get the C-style string (mutable)
        return UnsafePointer(cString!) // Convert to an immutable pointer
    case .failure(let error):
        let errorMessage = "Error: \(error)"
        let cString = strdup(errorMessage) // Get the C-style string (mutable)
        return UnsafePointer(cString!) // Convert to an immutable pointer
    }
}
#endif