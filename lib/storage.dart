import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/classes.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/global.dart' as global;

class Storage {
    Platform platform;
    SharedPreferencesAsync? android_storage;
    FlutterSecureStorage? ios_storage;

    Storage(this.platform, this.android_storage, this.ios_storage);

    factory Storage.init(Platform platform) {
        return switch(platform) {
            Platform.ios => Storage(platform, null, FlutterSecureStorage()),
            Platform.android => Storage(platform, SharedPreferencesAsync(), null),
            _ => Storage(platform, null, null),
        };
    }

    Future<void> write(String key, String value) async {
        switch(platform) {
            case Platform.ios: await this.ios_storage!.write(key: key, value: value);
            case Platform.android: await this.android_storage!.setString(key, value);
            default:  throw 'Unsupported Storage Platform';
        }
    }

    Future<String?> read(String key) async {
        switch(platform) {
            case Platform.ios: return await this.ios_storage!.read(key: key);
            case Platform.android: return await this.android_storage!.getString(key);
            default:  throw 'Unsupported Storage Platform';
        }
    }
}
