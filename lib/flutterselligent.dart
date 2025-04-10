import 'flutterselligent_platform_interface.dart';
import 'flutterselligent_constants.dart';

class Flutterselligent {
  Future<String> getVersionLib() {
    return FlutterselligentPlatform.instance.getVersionLib();
  }

  Future<String> getDeviceId() {
    return FlutterselligentPlatform.instance.getDeviceId();
  }

  Future<void> executePushAction() {
    return FlutterselligentPlatform.instance.executePushAction();
  }

  Future<void> applyLogLevel(LogLevel logLevel) {
    return FlutterselligentPlatform.instance.applyLogLevel(logLevel);
  }

  Future<void> enableNotifications(bool enabled) {
    return FlutterselligentPlatform.instance.enableNotifications(enabled);
  }

  Future<void> registerForProvisionalRemoteNotification() {
    return FlutterselligentPlatform.instance.registerForProvisionalRemoteNotification();
  }

  Future<void> displayLastReceivedNotification() {
    return FlutterselligentPlatform.instance.displayLastReceivedNotification();
  }

  Future<void> displayLastReceivedRemotePushNotification({String? templateId = ''}) {
    return FlutterselligentPlatform.instance.displayLastReceivedRemotePushNotification(templateId: templateId);
  }

  Future<RemoteNotificationData?> getLastRemotePushNotification() {
    return FlutterselligentPlatform.instance.getLastRemotePushNotification();
  }

  Future<void> enableInAppMessages(bool enabled) {
    return FlutterselligentPlatform.instance.enableInAppMessages(enabled);
  }

  Future<bool> areInAppMessagesEnabled() {
    return FlutterselligentPlatform.instance.areInAppMessagesEnabled();
  }

  Future<List<InAppMessageData>> getInAppMessages() {
    return FlutterselligentPlatform.instance.getInAppMessages();
  }

  Future<void> setInAppMessageAsSeen(String messageId) {
    return FlutterselligentPlatform.instance.setInAppMessageAsSeen(messageId);
  }

  Future<void> setInAppMessageAsUnseen(String messageId) {
    return FlutterselligentPlatform.instance.setInAppMessageAsUnseen(messageId);
  }

  Future<void> setInAppMessageAsDeleted(String messageId) {
    return FlutterselligentPlatform.instance.setInAppMessageAsDeleted(messageId);
  }

  Future<void> executeButtonAction(String buttonId, String messageId) {
    return FlutterselligentPlatform.instance.executeButtonAction(buttonId, messageId);
  }

  Future<void> displayNotification(String notificationId, {String? templateId = ''}) {
    return FlutterselligentPlatform.instance.displayNotification(notificationId, templateId: templateId);
  }

  Future<void> sendEvent(EventType type, String identifier, Map<Object?, Object?> data) {
    return FlutterselligentPlatform.instance.sendEvent(type, identifier, data);
  }

  Future<void> subscribeToEvents(List<String> events, {required Function(BroadcastEvent event) handle}) {
    return FlutterselligentPlatform.instance.subscribeToEvents(events, handle: handle);
  }
}

class BroadcastEvent {
  BroadcastEventType type;
  Object? data;

  BroadcastEvent(this.type, this.data);
}

class ButtonData {
  String id;
  String label;
  NotificationButtonType type;
  String value;
  Object? data;

  ButtonData(this.id, this.label, this.type, this.value, this.data);
}

class UniversalLinkData {
  String url;

  UniversalLinkData(this.url);
}

class NotificationData {
  String pushId;
  String name;

  NotificationData(this.pushId, this.name);
}

class DeviceIdData {
  String deviceId;

  DeviceIdData(this.deviceId);
}

class GcmTokenData {
  String token;

  GcmTokenData(this.token);
}

class InAppMessageEventListData {
  List<InAppMessageEventData> messages;

  InAppMessageEventListData(this.messages);
}

class InAppMessageEventData {
  String id;
  String title;

  InAppMessageEventData(this.id, this.title);
}

class RemoteNotificationData {
  String id;
  String title;

  RemoteNotificationData(this.id, this.title);
}

class InAppMessageData {
  String id;
  String title;
  String body;
  InAppMessageType type;
  int creationDate;
  int expirationDate;
  int receptionDate;
  bool hasBeenSeen;
  List<ButtonData> buttons;

  InAppMessageData(this.id, this.title, this.body, this.type, this.creationDate, this.expirationDate, this.receptionDate, this.hasBeenSeen, this.buttons);
}
