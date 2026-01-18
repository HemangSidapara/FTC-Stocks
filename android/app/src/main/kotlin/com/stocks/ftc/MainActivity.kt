package com.stocks.ftc

import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method.equals("installApk")) {
                installApk(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun installApk(result: MethodChannel.Result) {
        val fileName = "app-release.apk"

        val apkFile: File = File(this.getExternalFilesDir(null), fileName)
        Log.d("APK Installer", "installApk: $apkFile")
        if (apkFile.exists()) {
            val uri: Uri = FileProvider.getUriForFile(
                this,
                this.packageName + ".provider", apkFile
            )
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, "application/vnd.android.package-archive")
                flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(intent)
            result.success(true)
        } else {
            Log.e("APK Installer", "APK file not found: " + apkFile.absolutePath)
        }
    }

    companion object {
        private const val CHANNEL = "AndroidMethodChannel"
    }
}
