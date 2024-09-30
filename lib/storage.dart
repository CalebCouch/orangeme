import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:orange/classes.dart';

class Storage {
    PlatformE platform;
    SharedPreferencesAsync? android_storage;
    FlutterSecureStorage? ios_storage;

    Storage(this.platform, this.android_storage, this.ios_storage);

    factory init() {
        if Platform.isIOS {
            Storage(null, FlutterSecureStorage());
        } else if Platform.isAndroid {
            Storage(SharedPreferencesAsync(), null);
        }
    }
}
