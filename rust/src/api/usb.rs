use std::collections::HashSet;
use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;pub struct UsbInfo {
    pub baseline: Vec<PathBuf>, // Store baseline as a list of PathBuf objects
    pub device_path: Option<PathBuf>, // Option because the path might be None
}impl UsbInfo {
    // Method to query devices and return a vector of PathBufs
    pub async fn query_devices(os: &str) -> Vec<PathBuf> {
        let mut device_paths: Vec<PathBuf> = Vec::new();
        match os {
            "windows" => {
                // On Windows, use `wmic` to list logical disks (drives)
                match Command::new("wmic")
                    .args(&["logicaldisk", "get", "name"])
                    .output()
                {
                    Ok(output) => {
                        let result = String::from_utf8_lossy(&output.stdout);
                        for line in result.lines().filter(|l| !l.is_empty()) {
                            device_paths.push(PathBuf::from(line.trim()));
                        }
                    }
                    Err(e) => {
                        println!("Failed to query devices on Windows: {}", e);
                    }
                }
            }
            "linux" => {
                // On Linux, list the contents of `/media/$USER` or `/mnt`
                if let Some(user) = env::var_os("USER") {
                    let media_path = PathBuf::from(format!("/media/{}", user.to_string_lossy()));
                    match Command::new("ls")
                        .arg(&media_path)
                        .output()
                    {
                        Ok(output) => {
                            let result = String::from_utf8_lossy(&output.stdout);
                            for line in result.lines().filter(|l| !l.is_empty()) {
                                device_paths.push(media_path.join(line.trim()));
                            }
                        }
                        Err(_) => {
                            // If `/media/$USER` fails, fallback to `/mnt`
                            let mnt_path = PathBuf::from("/mnt");
                            match Command::new("ls")
                                .arg(&mnt_path)
                                .output()
                            {
                                Ok(output) => {
                                    let result = String::from_utf8_lossy(&output.stdout);
                                    for line in result.lines().filter(|l| !l.is_empty()) {
                                        device_paths.push(mnt_path.join(line.trim()));
                                    }
                                }
                                Err(e) => {
                                    println!("Failed to query devices on Linux: {}", e);
                                }
                            }
                        }
                    }
                }
            }
            "macos" => {
                // On macOS, list the contents of `/Volumes`
                let volumes_path = PathBuf::from("/Volumes");
                match Command::new("ls")
                    .arg(&volumes_path)
                    .output()
                {
                    Ok(output) => {
                        let result = String::from_utf8_lossy(&output.stdout);
                        for line in result.lines().filter(|l| !l.is_empty()) {
                            device_paths.push(volumes_path.join(line.trim()));
                        }
                    }
                    Err(e) => {
                        println!("Failed to query devices on macOS: {}", e);
                    }
                }
            }
            _ => {
                println!("Unsupported operating system");
            }
        }
        device_paths
    }    
    
    // Method to find the device path by comparing baseline and new snapshot
    pub async fn find_device_path(&mut self, os: &str) -> Option<PathBuf> {
        // Convert baseline into a HashSet of PathBufs for comparison
        let baseline_hash: HashSet<_> = self.baseline.iter().collect();        // Obtain a new snapshot of the device list
        let latest_snapshot = UsbInfo::query_devices(os).await;
        let latest_hash: HashSet<_> = latest_snapshot.iter().collect();        // Find the difference between the two sets and return the new device path
        for device in latest_hash.difference(&baseline_hash) {
            let new_device = (*device).clone();
            self.device_path = Some(new_device.clone());
            return Some(new_device);
        }        // If no new device was found, return None
        None
    }
}