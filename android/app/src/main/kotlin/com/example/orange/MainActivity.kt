package com.example.orange

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.content.Context;
import android.content.res.AssetManager;
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
        var inputStream: InputStream? = null
        var outputStream: OutputStream? = null
        return try {
            inputStream = assetManager.open(fromAssetPath)
            File(toPath).createNewFile()
            outputStream = FileOutputStream(toPath)
            copyFile(inputStream, outputStream)
            inputStream.close()
            inputStream = null
            outputStream.flush()
            outputStream.close()
            outputStream = null
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
                // The path where we expect the node project to be at runtime.
                val nodeDir = applicationContext.filesDir.absolutePath + "/nodejs"
// Recursively delete any existing nodejs-project.
                val nodeDirReference = File(nodeDir)
                if (nodeDirReference.exists()) {
                    deleteFolderRecursively(File(nodeDir))
                }
// Copy the node project from assets into the application's data path.
                copyAssetFolder(applicationContext.assets, "nodejs", nodeDir)
                startNodeWithArguments(arrayOf("node", "$nodeDir/main.js"))
            }).start()
        }
    }
}


