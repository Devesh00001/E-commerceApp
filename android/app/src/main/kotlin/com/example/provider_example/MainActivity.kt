package com.example.provider_example


import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL:String = "toast.flutter.io/toast"


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->if (call.method == "showToast") {
            Toast.makeText(applicationContext, "Add to cart", Toast.LENGTH_SHORT).show()
        } else {
            result.notImplemented()
        }



        }
    }
}
