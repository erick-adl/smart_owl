package erick.com.smartowl

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


class FloatWidgetService: Service() {

    companion object {
        const val CHANNEL = "erick.com.smartowl"
    }


    private var mWindowManager: WindowManager? = null
    private var mFloatingWidget: View? = null

    private val isViewCollapsed: Boolean
        get() = mFloatingWidget == null || mFloatingWidget!!.findViewById<View>(R.id.collapse_view).visibility == View.VISIBLE

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        mFloatingWidget = LayoutInflater.from(this).inflate(R.layout.layout_floating_widget, null)

        try {
            val params = WindowManager.LayoutParams(
                    WindowManager.LayoutParams.WRAP_CONTENT,
                    WindowManager.LayoutParams.WRAP_CONTENT,
                    WindowManager.LayoutParams.TYPE_PHONE,
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                    PixelFormat.TRANSLUCENT)



            params.gravity = Gravity.TOP or Gravity.LEFT
            params.x = 0
            params.y = 100
            mWindowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
            mWindowManager!!.addView(mFloatingWidget, params)
            val collapsedView = mFloatingWidget!!.findViewById<View>(R.id.collapse_view)
            val expandedView = mFloatingWidget!!.findViewById<View>(R.id.expanded_container)
            val closeButtonCollapsed = mFloatingWidget!!.findViewById<View>(R.id.close_btn) as ImageView
            closeButtonCollapsed.setOnClickListener { stopSelf() }
            val closeButton = mFloatingWidget!!.findViewById<View>(R.id.close_button) as ImageView
            closeButton.setOnClickListener {
                collapsedView.visibility = View.VISIBLE
                expandedView.visibility = View.GONE
            }
            mFloatingWidget!!.findViewById<View>(R.id.root_container).setOnTouchListener(object : View.OnTouchListener {
                private var initialX: Int = 0
                private var initialY: Int = 0
                private var initialTouchX: Float = 0.toFloat()
                private var initialTouchY: Float = 0.toFloat()

                override fun onTouch(v: View, event: MotionEvent): Boolean {
                    when (event.action) {
                        MotionEvent.ACTION_DOWN -> {
                            initialX = params.x
                            initialY = params.y
                            initialTouchX = event.rawX
                            initialTouchY = event.rawY
                            return true
                        }
                        MotionEvent.ACTION_UP -> {
                            val Xdiff = (event.rawX - initialTouchX).toInt()
                            val Ydiff = (event.rawY - initialTouchY).toInt()
                            if (Xdiff < 10 && Ydiff < 10) {
                                if (isViewCollapsed) {
                                    collapsedView.visibility = View.GONE
                                    expandedView.visibility = View.VISIBLE
                                }
                            }
                            return true
                        }
                        MotionEvent.ACTION_MOVE -> {
                            params.x = initialX + (event.rawX - initialTouchX).toInt()
                            params.y = initialY + (event.rawY - initialTouchY).toInt()
                            mWindowManager!!.updateViewLayout(mFloatingWidget, params)
                            return true
                        }
                    }

                    return false

                }
            })


            val leftButton = mFloatingWidget!!.findViewById<View>(R.id.left_button) as ImageView
            leftButton.setOnClickListener { it: View? ->
                Log.d("##{ CLICK }####", "LEFT BUTTON! ")
                Delegate.mainActivity?.sendCommand("button_left")
            }

            val rightButton = mFloatingWidget!!.findViewById<View>(R.id.right_button) as ImageView
            rightButton.setOnClickListener {
                Log.d("##{ CLICK }####", "RIGHT BUTTON! ")
                Delegate.mainActivity?.sendCommand("button_right")
            }

            val upButton = mFloatingWidget!!.findViewById<View>(R.id.up_button) as ImageView
            upButton.setOnClickListener {
                Log.d("##{ CLICK }####", "UP BUTTON! ")
                Delegate.mainActivity?.sendCommand("button_up")
            }

            val downButton = mFloatingWidget!!.findViewById<View>(R.id.down_button) as ImageView
            downButton.setOnClickListener {
                Log.d("##{ CLICK }####", "DOWN BUTTON! ")
                Delegate.mainActivity?.sendCommand("button_down")
            }

            val centerButton = mFloatingWidget!!.findViewById<View>(R.id.center_button) as ImageView
            centerButton.setOnClickListener {
                Log.d("##{ CLICK }####", "CENTER BUTTON! ")
                Delegate.mainActivity?.sendCommand("button_center")
            }

            val saveButton = mFloatingWidget!!.findViewById<View>(R.id.save_button) as ImageView
            saveButton.setOnClickListener {
                Log.d("##{ CLICK }####", "SAVE BUTTON! ")
                Delegate.mainActivity?.sendCommand("button_save")
            }

        } catch (e: Exception) {
            Log.d("##{ Exception }####", e.message)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (mFloatingWidget != null)
            mWindowManager!!.removeView(mFloatingWidget)
    }
}
