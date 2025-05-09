package com.selligent.flutterselligent

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import androidx.localbroadcastmanager.content.LocalBroadcastManager

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.selligent.fluttermobilesdk.Manager
import com.selligent.sdk.SMForegroundGcmBroadcastReceiver

class FlutterselligentPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private var activity: Activity? = null
  private var eventReceiver: EventReceiver? = null
  private lateinit var channel: MethodChannel
  private var receiver: SMForegroundGcmBroadcastReceiver? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutterselligent")
    channel.setMethodCallHandler(this)
    INSTANCE = this
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
    @SuppressLint("StaticFieldLeak")
    lateinit var INSTANCE: FlutterselligentPlugin

    fun configure(application: Application) {
      Manager.getInstance().configure(application, BuildConfig.SELLIGENT_SETTINGS, BuildConfig.BUILD_TYPE.equals("debug"))
    }
  }

  fun enableNotifications() {
    Manager.getInstance().enableNotifications(true)
  }

  fun onNewIntent(intent: Intent) {
    if (activity == null) { return }

    activity!!.intent = intent

    Manager.getInstance().checkAndDisplayMessage(intent, activity) { eventType, data ->
      broadcastEvent(eventType, eventType, data as HashMap)
    }
  }

  @SuppressLint("UnspecifiedRegisterReceiverFlag")
  fun onResume() {
    if (activity == null) { return }

    if (this.receiver == null) {
      this.receiver = SMForegroundGcmBroadcastReceiver(activity)
    }

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
      activity!!.registerReceiver(this.receiver, this.receiver!!.intentFilter, Context.RECEIVER_NOT_EXPORTED)
    }
    else {
      activity!!.registerReceiver(this.receiver, this.receiver!!.intentFilter)
    }

    Manager.getInstance().checkAndDisplayMessage(activity!!.intent, activity) { eventType, data ->
      broadcastEvent(eventType, eventType, data as HashMap)
    }
  }

  fun onPause() {
    if (activity == null) { return }

    activity!!.unregisterReceiver(this.receiver)
  }

  fun broadcastEvent(eventName: String, eventType: String, data: HashMap<String, Any>) {
    if (Manager.getInstance().canEmitEvent()) {
      var event = HashMap<String, Any>()
      event["name"] = eventName
      event["data"] = data
      event["broadcastEventType"] = eventType

      channel.invokeMethod("broadcastEvent", event)
    }
    else {
      Manager.getInstance().storeEvent(eventName, data)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    var flutterSelligent = Manager.getInstance()

    if (call.method == "getVersionLib") {
      result.success(flutterSelligent.versionLib)
    }
    else if (call.method == "getDeviceId") {
      result.success(flutterSelligent.deviceId)
    }
    else if (call.method == "executePushAction") {
      flutterSelligent.executePushAction(activity)
      result.success(true)
    }
    else if (call.method == "applyLogLevel") {
      Manager.setDebug(call.argument<Int>("logLevel") != 50)
      result.success(true)
    }
    else if (call.method == "enableNotifications") {
      (call.argument("enabled") as? Boolean)?.let { enabled ->
        flutterSelligent.enableNotifications(enabled)
      }

      result.success(true)
    }
    else if (call.method == "registerForProvisionalRemoteNotification") {
      result.success(true)
    }
    else if (call.method == "displayLastReceivedNotification") {
      flutterSelligent.displayLastReceivedNotification()
      result.success(true)
    }
    else if (call.method == "displayLastReceivedRemotePushNotification") {
      flutterSelligent.displayLastReceivedRemotePushNotification(activity)
      result.success(true)
    }
    else if (call.method == "getLastRemotePushNotification") {
      result.success(flutterSelligent.lastRemotePushNotification)
    }
    else if (call.method == "enableInAppMessages") {
      (call.argument("enabled") as? Boolean)?.let { enabled ->
        flutterSelligent.enableInAppMessages(enabled)
      }

      result.success(true)
    }
    else if (call.method == "areInAppMessagesEnabled") {
      result.success(flutterSelligent.areInAppMessagesEnabled())
    }
    else if (call.method == "getInAppMessages") {
      flutterSelligent.getInAppMessages { list ->
        result.success(list)
      }
    }
    else if (call.method == "setInAppMessageAsSeen") {
      flutterSelligent.setInAppMessageAsSeen(call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "setInAppMessageAsUnseen") {
      flutterSelligent.setInAppMessageAsUnseen(call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "setInAppMessageAsDeleted") {
      flutterSelligent.setInAppMessageAsDeleted(call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "executeButtonAction") {
      flutterSelligent.executeButtonAction(activity, call.argument<String>("buttonId"), call.argument<String>("messageId")) { error ->
        result.success(error)
      }
    }
    else if (call.method == "displayNotification") {
      flutterSelligent.displayMessage(call.argument<String>("notificationId"), activity)
      result.success(true)
    }
    else if (call.method == "sendEvent") {
      (call.argument("data") as? HashMap<String, Any>)?.let { data ->
        flutterSelligent.sendEvent(data, {}, {})
      }

      result.success(true)
    }
    else if (call.method == "subscribeToEvents") {
      if (activity is AppCompatActivity) {
        var compatActivity = activity as AppCompatActivity

        compatActivity.runOnUiThread {
          flutterSelligent.initializeObservers(compatActivity) { event, data ->
            broadcastEvent(event, event, data as HashMap)
          }
        }
      }
      else if (activity != null) {
        var localBroadcastManager = LocalBroadcastManager.getInstance(activity!!.applicationContext)

        if (this.eventReceiver == null) {
          this.eventReceiver = EventReceiver()
        }
        else {
          localBroadcastManager.unregisterReceiver(this.eventReceiver!!)
        }

        (call.argument("events") as? List<String>)?.let { events ->
          localBroadcastManager.registerReceiver(
            this.eventReceiver!!,
            Manager.eventsIntentFilter(events)
          )
        } ?: {
          localBroadcastManager.registerReceiver(
            this.eventReceiver!!,
            Manager.eventsIntentFilter(emptyList<String>())
          )
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
}