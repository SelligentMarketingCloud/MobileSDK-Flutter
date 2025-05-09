package com.selligent.flutterselligent

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.selligent.fluttermobilesdk.BroadcastDataFactory

class EventReceiver(): BroadcastReceiver() {
  override fun onReceive(p0: Context?, p1: Intent?) {
    var smBroadcastEventType = p1?.action

    if (smBroadcastEventType == null || smBroadcastEventType.isEmpty()) return

    var data = BroadcastDataFactory.getBroadcastData(smBroadcastEventType, p1) as HashMap
    var eventName = data["broadcastEventType"] as String

    if (!smBroadcastEventType.startsWith("SM")) {
      eventName = "TriggeredCustomEvent"
    }

    FlutterselligentPlugin.INSTANCE.broadcastEvent(
      eventName,
      data["broadcastEventType"] as String,
      data)
  }
}