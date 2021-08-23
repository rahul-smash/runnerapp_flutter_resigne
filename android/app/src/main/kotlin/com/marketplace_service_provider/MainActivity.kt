package com.marketplace_service_provider

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
//import io.flutter.app.FlutterActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var forService: Intent? = null
    private val CHANNEL = "com.marketplace_service_provider.messages"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        forService = Intent(this@MainActivity, TrackerService::class.java)

//        MethodChannel(getFlutterView(), "com.marketplace_service_provider.messages")
//                .setMethodCallHandler { methodCall, result ->
//                    if (methodCall.method == "startService") {
//                        startService()
//                        result.success("Service Started")
//                    }
//                }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopService(forService)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    // Note: this method is invoked on the main thread.
                    if (call.method == "startService") {
                        startService()
                        result.success("Service Started")
                    }
                }
    }

    private fun startService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(forService)
        } else {
            startService(forService)
        }
    }
}
