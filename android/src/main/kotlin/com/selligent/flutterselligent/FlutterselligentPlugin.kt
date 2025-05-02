package com.selligent.flutterselligent

import android.app.Activity
import android.app.Application
import androidx.appcompat.app.AppCompatActivity

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.selligent.fluttermobilesdk.Manager

import java.util.ArrayList
import java.util.Map

class FlutterselligentPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutterselligent")
    channel.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onReattachedToActivityForConfigChanges(binding:ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  companion object {
    fun configure(application: Application) {
      Manager.getInstance().configure(application, BuildConfig.SELLIGENT_SETTINGS, BuildConfig.BUILD_TYPE.equals("debug"))
    }

    fun enableNotifications() {
      Manager.getInstance().enableNotifications(true)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    var FlutterSelligent = Manager.getInstance()

    if (call.method == "getVersionLib") {
      result.success(FlutterSelligent.versionLib)
    }
    else if (call.method == "getDeviceId") {
      result.success(FlutterSelligent.deviceId)
    }
    else if (call.method == "executePushAction") {
      FlutterSelligent.executePushAction(activity)
      result.success(true)
    }
    else if (call.method == "applyLogLevel") {
      Manager.setDebug(call.argument<Int>("logLevel") != 50)
      result.success(true)
    }
    else if (call.method == "enableNotifications") {
      (call.argument("enabled") as? Boolean)?.let { enabled ->
        FlutterSelligent.enableNotifications(enabled)
      }

      result.success(true)
    }
    else if (call.method == "registerForProvisionalRemoteNotification") {
      result.success(true)
    }
    else if (call.method == "displayLastReceivedNotification") {
      FlutterSelligent.displayLastReceivedNotification()
      result.success(true)
    }
    else if (call.method == "displayLastReceivedRemotePushNotification") {
      FlutterSelligent.displayLastReceivedRemotePushNotification(activity)
      result.success(true)
    }
    else if (call.method == "getLastRemotePushNotification") {
      result.success(FlutterSelligent.lastRemotePushNotification)
    }
    else if (call.method == "enableInAppMessages") {
      (call.argument("enabled") as? Boolean)?.let { enabled ->
        FlutterSelligent.enableInAppMessages(enabled)
      }

      result.success(true)
    }
    else if (call.method == "areInAppMessagesEnabled") {
      result.success(FlutterSelligent.areInAppMessagesEnabled())
    }
    else if (call.method == "getInAppMessages") {
      FlutterSelligent.getInAppMessages { list ->
        result.success(list)
      }
    }
    else if (call.method == "setInAppMessageAsSeen") {
      FlutterSelligent.setInAppMessageAsSeen(call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "setInAppMessageAsUnseen") {
      FlutterSelligent.setInAppMessageAsUnseen(call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "setInAppMessageAsDeleted") {
      FlutterSelligent.setInAppMessageAsDeleted(call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "executeButtonAction") {
      FlutterSelligent.executeButtonAction(activity, call.argument<String>("buttonId"), call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "displayNotification") {
      FlutterSelligent.displayMessage(call.argument<String>("notificationId"), activity)
      result.success(true)
    }
    else if (call.method == "sendEvent") {
      (call.argument("data") as? HashMap<String, Any>)?.let { data ->
        FlutterSelligent.sendEvent(data, {}, {})
      }

      result.success(true)
    }
    else if (call.method == "subscribeToEvents") {
      if (activity is AppCompatActivity) {
        var compatActivity = activity as AppCompatActivity

        compatActivity.runOnUiThread {
          FlutterSelligent.initializeObservers(compatActivity) { event, data ->
            this.broadcastEvent(event, data as HashMap)
          }
        }
      }

      result.success(true)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun broadcastEvent(eventName: String, data: HashMap<String, Any>) {
    if (Manager.getInstance().canEmitEvent()) {
      var event = HashMap<String, Any>()
      event["name"] = eventName
      event["data"] = data
      event["broadcastEventType"] = eventName

      channel.invokeMethod("broadcastEvent", event)
    }
    else {
      Manager.getInstance().storeEvent(eventName, data)
    }
  }
}
