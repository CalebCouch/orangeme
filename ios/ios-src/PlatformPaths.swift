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

import UIKit

@_cdecl("trigger_haptic")
public func trigger_haptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
}
