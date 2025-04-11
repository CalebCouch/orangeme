use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let swift_file_a = "ios/ios-src/Notifications.swift";
    let swift_file_b = "ios/ios-src/Camera.swift";

    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let lib_path = out_dir.join("libmain.dylib");

    let status = Command::new("xcrun")
        .args([
            "--sdk", "macosx",
            "swiftc",
            "-target", "arm64-apple-macos13",
            "-emit-library",
            "-o", lib_path.to_str().unwrap(),
            "-framework", "AppKit",
            swift_file_a,
            swift_file_b,
        ])
        .status()
        .expect("failed to compile Swift code");

    if !status.success() {
        panic!("Swift compilation failed");
    }

    println!("cargo:rustc-link-search=native={}", out_dir.display());
    println!("cargo:rustc-link-lib=dylib=main");

    println!("cargo:rerun-if-changed={}", swift_file_a);
    println!("cargo:rerun-if-changed={}", swift_file_b);
}
