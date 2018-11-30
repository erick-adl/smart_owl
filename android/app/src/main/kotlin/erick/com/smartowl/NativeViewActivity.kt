package erick.com.smartowl

import android.os.Bundle
import android.util.Log
import android.widget.Button
import erick.com.smartowl.MainActivity
import erick.com.smartowl.R
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class NativeViewActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val channel = MethodChannel(flutterView, MainActivity.CHANNEL)

        setContentView(R.layout.layout)
        findViewById<Button>(R.id.button).setOnClickListener {
            channel.invokeMethod("message", "Hello!!! from Android native host")
        }
    }
}