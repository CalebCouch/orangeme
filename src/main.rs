fn main() {
    #[cfg(not(target_arch="wasm32"))]
    {
        orange::desktop_main()
    }
}
