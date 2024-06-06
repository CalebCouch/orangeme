# orange

Orange Flutter App

## Getting Started

Install flutter and ensure that flutter was not installed via snap

`ls ~/snap/flutter`  

To Fix local CORS:

`vim ~/flutter/packages/flutter_tools/lib/src/isolated/devfs_web.dart`

On Line 212 add these three lines :
`
    print('Temporary hack Flutter framework to add headers');
    httpServer!.defaultResponseHeaders.add('cross-origin-opener-policy', 'same-origin');
    httpServer!.defaultResponseHeaders.add('cross-origin-embedder-policy', 'require-corp');
`

`rm ~/flutter/bin/cache/flutter_tools.stamp`

Install deps

`sudo apt-get install \
      clang cmake git \
      ninja-build pkg-config \
      libgtk-3-dev liblzma-dev \
      libstdc++-12-dev`

Clone directory and cd into it

`flutter pub get`

Run this command to keep rust binary updated.

`flutter_rust_bridge_codegen generate --watch`

To startup the app

`flutter run`

