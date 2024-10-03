use std::collections::HashSet;
use std::env;
use std::process::Command;
// use tokio::process::Command as TokioCommand;

/// flutter_rust_bridge:ignore
pub struct UsbInfo {
   pub baseline: String,
   pub device_path: String,
}

impl UsbInfo {
    // Method to query devices and store the result in baseline
    pub async fn query_devices(os: &str) -> String {
        let mut device_baseline = String::new();
        match os {
            "windows" => {
                // On Windows, use `wmic` to list logical disks (drives)
                match Command::new("wmic")
                    .args(&["logicaldisk", "get", "name"])
                    .output()
                {
                    Ok(output) => {
                        let result = String::from_utf8_lossy(&output.stdout);
                        device_baseline = result.into_owned();
                    }
                    Err(e) => {
                        println!("Failed to query devices on Windows: {}", e);
                        return "None".to_string();
                    }
                }
            }
            "linux" => {
                // On Linux, list the contents of `/media/$USER` or `/mnt`
                if let Some(user) = env::var_os("USER") {
                    let media_path = format!("/media/{}", user.to_string_lossy());
                    match Command::new("ls")
                        .arg(&media_path)
                        .output()
                    {
                        Ok(output) => {
                            let result = String::from_utf8_lossy(&output.stdout);
                            device_baseline = result.into_owned();
                        }
                        Err(_) => {
                            // If `/media/$USER` fails, fallback to `/mnt`
                            match Command::new("ls")
                                .arg("/mnt")
                                .output()
                            {
                                Ok(output) => {
                                    let result = String::from_utf8_lossy(&output.stdout);
                                    device_baseline = result.into_owned();
                                }
                                Err(e) => {
                                    println!("Failed to query devices on Linux: {}", e);
                                    return "None".to_string();
                                }
                            }
                        }
                    }
                }
            }
            "macos" => {
                // On macOS, list the contents of `/Volumes`
                match Command::new("ls")
                    .arg("/Volumes")
                    .output()
                {
                    Ok(output) => {
                        let result = String::from_utf8_lossy(&output.stdout);
                        device_baseline = result.into_owned();
                    }
                    Err(e) => {
                        println!("Failed to query devices on macOS: {}", e);
                        return "None".to_string();
                    }
                }
            }
            _ => {
                println!("Unsupported operating system");
                return "None".to_string();
            }
        }
        // Return the device baseline if found
        device_baseline
    }   
    
    
    // Method to find the device path by comparing baseline and new snapshot
    pub async fn find_device_path(&mut self, os: &str) -> String {
        // Convert baseline query (first snapshot) into a HashSet
        let baseline_hash: HashSet<_> = self.baseline.lines().collect();
        // Obtain a new snapshot of the device list
        let latest_snapshot = UsbInfo::query_devices(os).await;
        // Convert new snapshot into a HashSet
        let new_hash: HashSet<_> = latest_snapshot.lines().collect();        // Find the difference between the two sets and return the new device path
        for device in new_hash.difference(&baseline_hash) {
            self.device_path = device.to_string(); // Store the first difference found
            return self.device_path.clone();
        }
        // If no new device was found, return None
        "None".to_string()
    }
}
