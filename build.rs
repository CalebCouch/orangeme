use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    // Path to your Swift source file
    let swift_file = "ios/ios-src/PlatformPaths.swift"; // update to your path

    // Where to output the compiled dylib
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let lib_path = out_dir.join("libmain.dylib");

    // Compile the Swift file into a dynamic library for macOS
    let status = Command::new("xcrun")
        .args([
            "--sdk", "macosx",
            "swiftc",
            "-target", "arm64-apple-macos13",
            "-emit-library",
            "-o", lib_path.to_str().unwrap(),
            "-framework", "AppKit",
            swift_file,
        ])
        .status()
        .expect("failed to compile Swift code");

    if !status.success() {
        panic!("Swift compilation failed");
    }

    // Tell Rust to link to the compiled Swift dylib
    println!("cargo:rustc-link-search=native={}", out_dir.display());
    println!("cargo:rustc-link-lib=dylib=main");

    // Re-run if the Swift file changes
    println!("cargo:rerun-if-changed={}", swift_file);
}
