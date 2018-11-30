package erick.com.smartowl

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.util.Log

class MainActivity: FlutterActivity() {
  companion object {
    const val CHANNEL = "erick.com.smartowl"
    // private val TAG = MainActivity::class.qualifiedName
    // private val REQUEST_OVERLAY_PERMISSION = 1
  }

  private val REQUEST_OVERLAY_PERMISSION = 1
  private val TAG = "MainActivity"

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
      super.onActivityResult(requestCode, resultCode, data)
      if (resultCode == RESULT_OK) {
        when (requestCode) {
          REQUEST_OVERLAY_PERMISSION -> Log.d(TAG, "enable overlay permission")
        }
      }
    }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    val channel = MethodChannel(flutterView, CHANNEL)
    // Thread {
    //   while (true) {
    //     channel.invokeMethod("message", "Ola, eu sou o android nativo.")
    //     Thread.sleep(1_000)  // wait for 1 second
    //     channel.invokeMethod("message", "Ola, eu sou o android nativo..")
    //     Thread.sleep(1_000)  // wait for 1 second
    //     channel.invokeMethod("message", "Ola, eu sou o android nativo...")
    //     Thread.sleep(1_000)  // wait for 1 second
    //   }
    // }.start()

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "StartBubble") {
          Log.d("####{ 1 }####", "CHEGUEI AQUI! ")

      //  val intent = Intent(this, NativeViewActivity::class.java)
      //   startActivity(intent)

         if (hasOverlayPermission()) {
          startService(Intent(this@MainActivity, FloatWidgetService::class.java))
           result.success(true)
        } else {
           requestOverlayPermission(REQUEST_OVERLAY_PERMISSION)
         }
         result.success(true)
      }
      else if (call.method == "getData") {
        Log.d("####{ 2 }####", "CHEGUEI AQUI! ")
        channel.invokeMethod("message", "Ola, eu sou o android nativo...")
        result.success(true)

      } else {
        Log.d("####{ 3 }####", "CHEGUEI AQUI! ")
        result.notImplemented()
      }
    }





  }
}
