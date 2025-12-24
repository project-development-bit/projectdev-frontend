package com.be.gigafaucet

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channelName = "app.splash"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"hide" -> {
						// Clear the window background so the launch drawable doesn't linger behind Flutter.
						window.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
						result.success(null)
					}
					else -> result.notImplemented()
				}
			}
	}
}
