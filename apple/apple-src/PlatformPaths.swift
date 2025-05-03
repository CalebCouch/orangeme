import Foundation

 //  xcrun --sdk macosx swiftc \
    //  -target arm64-apple-macos13 \
    // apple/apple-src/PlatformPaths.swift

fileprivate var appSupportPathCString: UnsafePointer<CChar>? = nil

@_cdecl("get_application_support_dir")
public func get_application_support_dir() -> UnsafePointer<CChar>? {
    let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    guard let url = urls.first else { return nil }
    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

    let path = url.path
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

#else

import AppKit

@_cdecl("get_clipboard_string")
public func get_clipboard_string() -> UnsafeMutablePointer<CChar>? {
    let pasteboard = NSPasteboard.general
    
    if let availableTypes = pasteboard.types {
        if availableTypes.contains(NSPasteboard.PasteboardType("NSStringPboardType")) {
            if let copiedString = pasteboard.string(forType: .string) {
                return strdup(copiedString)
            }
        }
    }
    return nil
}


#endif
