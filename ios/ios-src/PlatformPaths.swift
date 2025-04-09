import Foundation

// Static to hold a C-compatible path forever (not freed)
fileprivate var appSupportPathCString: UnsafePointer<CChar>? = nil

@_cdecl("get_application_support_dir")
public func get_application_support_dir() -> UnsafePointer<CChar>? {
    let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    guard let url = urls.first else { return nil }

    // Ensure the directory exists
    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

    let path = url.path

    // Store the C string in a static so it stays alive
    appSupportPathCString = (path as NSString).utf8String
    return appSupportPathCString
}

#if os(iOS)
import UIKit

@_cdecl("get_clipboard_string")
public func get_clipboard_string() -> UnsafeMutablePointer<CChar>? {
    if let string = UIPasteboard.general.string {
        return strdup(string)
    }
    return nil
}

@_cdecl("trigger_haptic")
public func trigger_haptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
}


// MARK: - File-global variable to hold the array
var insetsArray: [Double] = [0, 0, 0, 0]

@_cdecl("get_safe_area_insets")
public func get_safe_area_insets() -> UnsafePointer<Double> {
    if let window = UIApplication.shared.windows.first {
        let insets = window.safeAreaInsets
        insetsArray[0] = Double(insets.top)
        insetsArray[1] = Double(insets.bottom)
        insetsArray[2] = Double(insets.left)
        insetsArray[3] = Double(insets.right)
    }

    return insetsArray.withUnsafeBufferPointer { $0.baseAddress! }
}
#endif