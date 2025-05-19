// #if os(iOS)
// import UIKit
// #else
// import AppKit
// #endif
// import AVFoundation
// import Foundation

// public enum CameraError: Error {
//     case accessDenied
//     case restricted
//     case unknown
//     case waitingForAccess
// }

// var latestFramePtr: UnsafeMutableRawPointer?
// var initialFrameSize: Int = 0
// var latestPixelBuffer: CVPixelBuffer?
// var cameraCaptureInstance: CameraCapture?

// public class CameraCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//     private let session = AVCaptureSession()

//     override init() {
//         super.init()
//         setupCamera()
//     }

//     public func setupCamera() {
//         guard let device = AVCaptureDevice.default(for: .video),
//               let input = try? AVCaptureDeviceInput(device: device) else {
//             print("Failed to initialize camera.")
//             return
//         }

//         session.beginConfiguration()
//         session.sessionPreset = .medium

//         if session.canAddInput(input) {
//          
//    session.addInput(input)
//         }

//       
//   let output = AVCaptureVideoDataOutput()
//         output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
//         output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraQueue"))

//         if session.canAddOutput(output) {
//             session.addOutput(output)
//         }

//         session.commitCo
// nfiguration()
//         session.startRunning()
//     }

//     public func captureOutput(
//         _ output: AVCaptureOutput,
//         didOutput sampleBuffer: CMSampleBuffer,
//         from connection: AVCaptureConnection
//     ) {
//         guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

//         if initialFrameSize == 0 {
//             let width = CVPixelBufferGetWidth(pixelBuffer)
//             let height = CVPixelBufferGetHeight(pixelBuffer)
//             initialFrameSize = CVPixelBufferGetBytesPerRow(pixelBuffer) * height
//             print("First frame width: \(width), height: \(height)")
//         }

//         CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
//         guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
//             CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
//             return
//         }

//         let size = initialFrameSize
//         if latestFramePtr == nil || initialFrameSize != size {
//             if let ptr = latestFramePtr {
//                 free(ptr)
//             }
//             latestFramePtr = malloc(size)
//         }

//         memcpy(latestFramePtr, baseAddress, size)
//         latestPixelBuffer = pixelBuffer
//         CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
//     }

//     public func checkCameraAccess() -> Result<String, CameraError> {
//         switch AVCaptureDevice.authorizationStatus(for: .video) {
//         case .authorized:
//             return .success("cameraEnabled")
//         case .denied:
//             return .failure(.accessDenied)
//         case .restricted:
//             return .failure(.restricted)
//         case .notDetermined:
//             return .failure(.waitingForAccess)
//         @unknown default:
//             return .failure(.unknown)
//         }
//     }

//     public func requestCameraAccess() {
//         AVCaptureDevice.requestAccess(for: .video) { response in }
//     }
// }

// @_cdecl("start_camera_capture")
// public func start_camera_capture() {
//     DispatchQueue.main.async {
//         if cameraCaptureInstance == nil {
//             cameraCaptureInstance = CameraCapture()
//             print("Camera started")
//         }
//     }
// }

// @_cdecl("get_initial_frame_width")
// public func get_initial_frame_width() -> Int {
//     guard let pixelBuffer = latestPixelBuffer else { return 0 }
//     return CVPixelBufferGetWidth(pixelBuffer)
// }

// @_cdecl("get_initial_frame_height")
// public func get_initial_frame_height() -> Int {
//     guard let pixelBuffer = latestPixelBuffer else { return 0 }
//     return CVPixelBufferGetHeight(pixelBuffer) 
// }

// @_cdecl("get_latest_frame")
// public func get_latest_frame() -> UnsafeMutableRawPointer? {
//     return latestFramePtr
// }

// @_cdecl("get_initial_frame_size")
// public func get_initial_frame_size() -> Int {
//     return initialFrameSize
// }

// @_cdecl("get_latest_frame_stride")
// public func get_latest_frame_stride() -> Int {
//     guard let pixelBuffer = latestPixelBuffer else { return 0 }
//     return CVPixelBufferGetBytesPerRow(pixelBuffer)
// }

// @_cdecl("check_camera_access")
// public func check_camera_access() -> UnsafeMutablePointer<CChar>? {
//     let result: Result<String, CameraError> = cameraCaptureInstance?.checkCameraAccess() ?? .failure(.unknown)

//     switch result {
//     case .success(let successMessage):
//         return strdup(successMessage)
//     case .failure(let error):
//         return strdup("Error: \(error)")
//     }
// }
