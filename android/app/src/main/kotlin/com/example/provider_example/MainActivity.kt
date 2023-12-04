package com.example.provider_example

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.Build
import android.os.Bundle

import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterFragmentActivity
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "toast.flutter.io/toast"
    private val CHANNEL2 = "flashlight"

    


    private var cameraManager: CameraManager? = null
    private var flash = false

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine)  {
        super.configureFlutterEngine(flutterEngine)
        
        


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "showToast") {
                Toast.makeText(applicationContext, "Add to cart", Toast.LENGTH_SHORT).show()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL2
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "flashlight") {
                cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager

                if (packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)) {
                    if (packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
                        if (!flash) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                try {
                                    cameraManager?.setTorchMode("0", true)
                                    flash = true
                                    result.success("Flashlight turned on")
                                } catch (e: CameraAccessException) {
                                    result.error("CAMERA_ERROR", "Error accessing the camera.", null)
                                }
                            }
                        } else {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                try {
                                    cameraManager?.setTorchMode("0", false)
                                    flash = false
                                    result.success("Flashlight turned off")
                                } catch (e: CameraAccessException) {
                                    result.error("CAMERA_ERROR", "Error accessing the camera.", null)
                                }
                            }
                        }
                    } else {
                        result.error("NO_FLASH", "This device has no flash", null)
                    }
                } else {
                    result.error("NO_CAMERA", "This device has no camera", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
   
}
