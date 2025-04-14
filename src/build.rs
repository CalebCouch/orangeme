fn main() {
        let swift_file_a = "apple/apple-src/Notifications.swift";
        let swift_file_b = "apple/apple-src/Camera.swift";
        let swift_file_c = "apple/apple-src/PlatformPaths.swift";

        let out_dir = std::path::PathBuf::from(std::env::var("OUT_DIR").unwrap());
        let lib_path = out_dir.join("libmain.dylib");

        let status = std::process::Command::new("xcrun")
            .args([
                "--sdk", "macosx",
                "swiftc",
                "-target", "arm64-apple-macos13",
                "-emit-library",
                "-o", lib_path.to_str().unwrap(),
                "-framework", "AppKit",
                swift_file_a,
                swift_file_b,
                swift_file_c
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