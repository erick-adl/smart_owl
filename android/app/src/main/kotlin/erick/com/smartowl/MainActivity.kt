package erick.com.smartowl

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.util.Log
import java.lang.Exception

class MainActivity : FlutterActivity() {


    companion object {
        const val CHANNEL = "erick.com.smartowl"

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

    fun sendCommand(command: String) {
        Log.d("##{ COMMAND }####", command)
        channel.invokeMethod(command, boardName)
        Log.d("##{ COMMAND }####", "DEU CERTO")
    }

    var channel = MethodChannel(flutterView, CHANNEL)

    private var boardName = ""

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        Delegate.mainActivity = this

        channel = MethodChannel(flutterView, CHANNEL)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            try {
                if (call.method == "StartBubble") {
                    Log.d("KOTLIN", "Chamei StartBubble")
                    if (hasOverlayPermission()) {
                        Log.d("KOTLIN", "Tenho permissão")
                        startService(Intent(this@MainActivity, FloatWidgetService::class.java))
                        result.success(true)
                    } else {
                        Log.d("KOTLIN", "Não tenho permissão")
                        requestOverlayPermission(REQUEST_OVERLAY_PERMISSION)
                        result.success(false)
                    }
                    boardName = call.arguments.toString()

                } else {
                    Log.d("KOTLIN", "OPA! METODO NÃO EXISTE!")
                    result.notImplemented()
                }

            } catch (e: Exception) {
                Log.d("KOTLIN", "OPA! DEU MERDA: ${e.message}")
                Log.d("KOTLIN", "OPA! DEU MERDA: ${e.cause}")
            }
        }
    }
}
