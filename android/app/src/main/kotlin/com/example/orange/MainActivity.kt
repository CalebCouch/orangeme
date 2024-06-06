package com.example.orange

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class MainActivity: FlutterActivity() {
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
                startNodeWithArguments(arrayOf("node", "-e", """
                var http = require('http');
                var versions_server = http.createServer((request, response) => {
                  response.end('Versions: ' + JSON.stringify(process.versions));
                });
                versions_server.listen(3000);
            """.trimIndent()))
            }).start()
        }
    }
}
