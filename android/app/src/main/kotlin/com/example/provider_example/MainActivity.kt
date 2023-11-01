package com.example.provider_example


import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.IMPORTANCE_MAX
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL:String = "toast.flutter.io/toast"
    private val CHANNEL2:String = "flashlight"

    private var cameraManager: CameraManager? = null
     var Flash:Boolean = false;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "your_channel",
                "Your Channel Name",
                NotificationManager.IMPORTANCE_MAX // Set importance to high (max)
            )

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
   
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "showToast") {
                Toast.makeText(applicationContext, "Add to cart", Toast.LENGTH_SHORT).show()
            } else {
                result.notImplemented()
            }

        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL2
        ).setMethodCallHandler { call, result ->
            if (call.method == "flashlight") {
                cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager;

                if (packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)) {
                    if (packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
                        if(Flash == false) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                cameraManager!!.setTorchMode("0", true)
                            }
                        }else{
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                cameraManager!!.setTorchMode("0", false)
                            }
                        }
                        Flash = !Flash


                    } else {
                        print("This device has no flash");
                    }
                } else {
                    print("This device has no camera");
                }
            }
        }
    }
}
