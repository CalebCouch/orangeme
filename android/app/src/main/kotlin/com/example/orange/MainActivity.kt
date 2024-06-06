package com.example.orange

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.content.Context;
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.res.AssetManager;
import android.util.Log
import java.io.*;

class MainActivity: FlutterActivity() {

    private fun deleteFolderRecursively(file: File): Boolean {
        return try {
            var res = true
            file.listFiles()?.forEach { childFile ->
                if (childFile.isDirectory) {
                    res = res && deleteFolderRecursively(childFile)
                } else {
                    res = res && childFile.delete()
                }
            }
            res = res && file.delete()
            res
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun copyAssetFolder(assetManager: AssetManager, fromAssetPath: String, toPath: String): Boolean {
        return try {
            val files = assetManager.list(fromAssetPath)
            var res = true

            if (files != null) {
                if (files.isEmpty()) {
                    // If it's a file, it won't have any assets "inside" it.
                    res = copyAsset(assetManager, fromAssetPath, toPath)
                } else {
                    File(toPath).mkdirs()
                    for (file in files) {
                        res = res && copyAssetFolder(assetManager, "$fromAssetPath/$file", "$toPath/$file")
                    }
                }
            }
            res
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun copyAsset(assetManager: AssetManager, fromAssetPath: String, toPath: String): Boolean {
        var inputStream: InputStream?
        var outputStream: OutputStream?
        return try {
            inputStream = assetManager.open(fromAssetPath)
            File(toPath).createNewFile()
            outputStream = FileOutputStream(toPath)
            copyFile(inputStream, outputStream)
            inputStream.close()
            outputStream.flush()
            outputStream.close()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    @Throws(IOException::class)
    private fun copyFile(inputStream: InputStream, outputStream: OutputStream) {
        val buffer = ByteArray(1024)
        var read: Int
        while (inputStream.read(buffer).also { read = it } != -1) {
            outputStream.write(buffer, 0, read)
        }
    }

    private fun wasAPKUpdated(): Boolean {
        val prefs = applicationContext.getSharedPreferences("NODEJS_MOBILE_PREFS", Context.MODE_PRIVATE)
        val previousLastUpdateTime = prefs.getLong("NODEJS_MOBILE_APK_LastUpdateTime", 0)
        var lastUpdateTime: Long = 1
        try {
            val packageInfo: PackageInfo = applicationContext.packageManager.getPackageInfo(applicationContext.packageName, 0)
            lastUpdateTime = packageInfo.lastUpdateTime
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return lastUpdateTime != previousLastUpdateTime
    }

    private fun saveLastUpdateTime() {
        var lastUpdateTime: Long = 1
        try {
            val packageInfo: PackageInfo = applicationContext.packageManager.getPackageInfo(applicationContext.packageName, 0)
            lastUpdateTime = packageInfo.lastUpdateTime
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        val prefs = applicationContext.getSharedPreferences("NODEJS_MOBILE_PREFS", Context.MODE_PRIVATE)
        val editor = prefs.edit()
        editor.putLong("NODEJS_MOBILE_APK_LastUpdateTime", lastUpdateTime)
        editor.commit()
    }

    init {
        System.loadLibrary("native-lib")
    }

    external fun startNodeWithArguments(args: Array<String>): Void

    var _startedNodeAlready: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)



        if (!_startedNodeAlready) {
            _startedNodeAlready = true
            Thread(Runnable {
                val nodeDir = applicationContext.filesDir.absolutePath + "/nodejs"
                if (wasAPKUpdated()) {
                    val nodeDirReference = File(nodeDir)
                    if (nodeDirReference.exists()) {
                        deleteFolderRecursively(File(nodeDir))
                    }
                    copyAssetFolder(applicationContext.assets, "nodejs", nodeDir)
                    saveLastUpdateTime();
                }
                startNodeWithArguments(arrayOf("node", "$nodeDir/main.js"))
            }).start()
        }
    }
}


