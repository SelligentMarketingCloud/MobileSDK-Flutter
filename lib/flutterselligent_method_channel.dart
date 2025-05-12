import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'flutterselligent_platform_interface.dart';
import 'flutterselligent.dart';
import 'flutterselligent_constants.dart';

class MethodChannelFlutterselligent extends FlutterselligentPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutterselligent');

  final log = Logger('FlutterSelligent');
  Function(BroadcastEvent event) handleEvents = ((BroadcastEvent event) {});
  GlobalKey<NavigatorState>? appNavigatorKey;
  String displayingIAM = "";

  MethodChannelFlutterselligent() {
    log.onRecord.listen((record) {
      debugPrint('[FlutterSelligent] ${record.message}');
    });

    if (Platform.environment.containsKey('FLUTTER_TEST')) { return; }

    methodChannel.setMethodCallHandler((call) async {
      var eventType = call.arguments['broadcastEventType'];
      var data = getData(call.arguments['data']);

      if (call.method == 'broadcastEvent') {
        if (eventType == BroadcastEventType.buttonClick.value) {
          handleEvents(BroadcastEvent(
            BroadcastEventType.buttonClick,
            ButtonData(
              data['id'] as String,
              data['label'] as String,
              NotificationButtonType.getByValue(data['type'] as int),
              data['value'] as String,
              data['data']
            )
          ));
        }
        else if (eventType == BroadcastEventType.universalLink.value) {
          handleEvents(BroadcastEvent(
            BroadcastEventType.universalLink,
            UniversalLinkData(data['url'] as String)
          ));
        }
        else if (eventType == BroadcastEventType.receivedNotification.value) {
          handleEvents(BroadcastEvent(
            BroadcastEventType.receivedNotification,
            NotificationData(
              data['pushId'] as String,
              data['name'] as String
            )
          ));
        }
        else if (eventType == BroadcastEventType.receivedIAM.value) {
          List<InAppMessageEventData> newMessages = [];

          for (var message in data['messages']) {
            newMessages.add(InAppMessageEventData(message['id'] as String, message['title'] as String));
          }

          handleEvents(BroadcastEvent(
            BroadcastEventType.receivedIAM,
            InAppMessageEventListData(
              newMessages
            )
          ));
        }
        else if (eventType == BroadcastEventType.receiveDeviceId.value) {
          handleEvents(BroadcastEvent(
            BroadcastEventType.receiveDeviceId,
            DeviceIdData(data['deviceId'] as String)
          ));
        }
        else if (eventType == BroadcastEventType.receivedGcmToken.value) {
          handleEvents(BroadcastEvent(
            BroadcastEventType.receivedGcmToken,
            GcmTokenData(data['token'] as String)
          ));
        }
        else if (eventType == BroadcastEventType.displayingIAM.value) {
          var messageId = data['id'] as String;

          await displayIAM(messageId);

          handleEvents(BroadcastEvent(
            BroadcastEventType.displayingIAM,
            InAppMessageEventData(
              messageId,
              data['title'] as String
            )
          ));
        }
        else if (eventType == BroadcastEventType.displayNotification.value) {
          handleEvents(BroadcastEvent(BroadcastEventType.displayNotification, null));
        }
        else if (eventType == BroadcastEventType.dismissNotification.value) {
          displayingIAM = "";
          handleEvents(BroadcastEvent(BroadcastEventType.dismissNotification, null));
        }
        else if (call.arguments['name'] == BroadcastEventType.customEvent.value) {
          handleEvents(BroadcastEvent(BroadcastEventType.customEvent, eventType));
        }
      } 
      else {
        log.warning('Method not implemented: ${call.method}');
      }
    });
  }

  @override
  Future<String> getVersionLib() async {
    try {
      return await methodChannel.invokeMethod<String>('getVersionLib') ?? '';
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when getting the library version: ${exception.message}');
      return '';
    }
  }

  @override
  Future<String> getDeviceId() async {
    try {
      return await methodChannel.invokeMethod<String>('getDeviceId') ?? '';
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when getting the device id: ${exception.message}');
      return '';
    }
  }

  @override
  Future<void> executePushAction(GlobalKey<NavigatorState> navigatorKey) async {
    try {
      appNavigatorKey = navigatorKey;
      await methodChannel.invokeMethod('executePushAction');
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when executing the push action: ${exception.message}');
    }
  }

  @override
  Future<void> applyLogLevel(LogLevel logLevel) async {
    try {
      await methodChannel.invokeMethod('applyLogLevel', { 'logLevel': logLevel.value });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when setting the log level: ${exception.message}');
    }
  }

  @override
  Future<void> enableNotifications(bool enabled) async {
    try {
      await methodChannel.invokeMethod('enableNotifications', { 'enabled': enabled });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when enabling notifications: ${exception.message}');
    }
  }

  @override
  Future<void> registerForProvisionalRemoteNotification() async {
    try {
      await methodChannel.invokeMethod('registerForProvisionalRemoteNotification');
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when enabling provisional notifications: ${exception.message}');
    }
  }

  @override
  Future<void> displayLastReceivedNotification() async {
    try {
      await methodChannel.invokeMethod('displayLastReceivedNotification');
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when displaying last received notification: ${exception.message}');
    }
  }

  @override
  Future<void> displayLastReceivedRemotePushNotification({String? templateId = ''}) async {
    try {
      await methodChannel.invokeMethod('displayLastReceivedRemotePushNotification', { 'templateId': templateId });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when displaying last received notification: ${exception.message}');
    }
  }

  @override
  Future<RemoteNotificationData?> getLastRemotePushNotification() async {
    try {
      var notification = await methodChannel.invokeMethod('getLastRemotePushNotification');

      if (notification == null || notification['id'] == null || notification['title'] == null) { return null; }
      
      return RemoteNotificationData(notification['id'] as String, notification['title'] as String);
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when displaying last received notification: ${exception.message}');
      return null;
    }
  }

  @override
  Future<void> enableInAppMessages(bool enabled) async {
    try {
      await methodChannel.invokeMethod('enableInAppMessages', { 'enabled': enabled });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when enabling inapp messages: ${exception.message}');
    }
  }

  @override
  Future<bool> areInAppMessagesEnabled() async {
    try {
      return await methodChannel.invokeMethod('areInAppMessagesEnabled');
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when getting inapp messages status: ${exception.message}');
      return false;
    }
  }

  @override
  Future<List<InAppMessageData>> getInAppMessages() async {
    try {
      List<Object?> messages = await methodChannel.invokeMethod('getInAppMessages');
      return messages.map((m) { 
        var message = m as Map<Object?, Object?>;
        var buttons = message['buttons'] as List<Object?>;

        return InAppMessageData(
          message['id'] as String, 
          message['title'] as String, 
          message['body'] as String, 
          InAppMessageType.getByValue(message['type'] as int), 
          getDate(message['creationDate']), 
          getDate(message['expirationDate']),
          getDate(message['receptionDate']),
          message['hasBeenSeen'] as bool,
          buttons.map((b) {
            var button = b as Map<Object?, Object?>;
            return ButtonData(
              button['id'] as String, 
              button['label'] as String, 
              NotificationButtonType.getByValue(button['type'] as int), 
              button['value'] as String, 
              button['data']
            );
          }).toList()
        );
      }).toList();
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when getting inapp messages status: ${exception.message}');
      return [];
    }
  }

  @override
  Future<void> setInAppMessageAsSeen(String messageId) async {
    try {
      var result = await methodChannel.invokeMethod('setInAppMessageAsSeen', { 'messageId': messageId });

      if (result != null) log.warning(result);
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when setting inapp message as seen: ${exception.message}');
    }
  }

  @override
  Future<void> setInAppMessageAsUnseen(String messageId) async {
    try {
      var result = await methodChannel.invokeMethod('setInAppMessageAsUnseen', { 'messageId': messageId });

      if (result != null) log.warning(result);
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when setting inapp message as unseen: ${exception.message}');
    }
  }

  @override
  Future<void> setInAppMessageAsDeleted(String messageId) async {
    try {
      var result = await methodChannel.invokeMethod('setInAppMessageAsDeleted', { 'messageId': messageId });

      if (result != null) log.warning(result);
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when setting inapp message as deleted: ${exception.message}');
    }
  }

  @override
  Future<void> executeButtonAction(String buttonId, String messageId) async {
    try {
      var result = await methodChannel.invokeMethod('executeButtonAction', { 
        'buttonId': buttonId,
        'messageId': messageId 
      });

      if (result != null) log.warning(result);
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when executing button action: ${exception.message}');
    }
  }

  @override
  Future<void> displayNotification(String notificationId, {String? templateId = ''}) async {
    await displayIAM(notificationId, templateId: templateId);
  }

  @override
  Future<void> sendEvent(EventType type, String identifier, Map<Object?, Object?> data) async {
    try {
      await methodChannel.invokeMethod('sendEvent', {
        'data': {
          'type': EventType.getByType(type),
          'email': identifier,
          'data': data 
        }
      });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when displaying the notification: ${exception.message}');
    }
  }

  @override
  Future<void> subscribeToEvents(List<String> events, {required Function(BroadcastEvent event) handle}) async {
    try {
      handleEvents = handle;
      await methodChannel.invokeMethod('subscribeToEvents', { 'events': events });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when subscribing to events: ${exception.message}');
    }
  }

  int getDate(Object? input) {
    if (input is int) {
      return input;
    }

    return (input as double).toInt();
  }

  dynamic getData(dynamic data) {
    if (data is Map && data['data'] != null) {
      return data['data'];
    }

    return data;
  }

  Future<void> displayIAM(String messageId, {String? templateId = ''}) async {
    var appContext = appNavigatorKey?.currentState?.overlay?.context;
    var messages = await getInAppMessages();
    var message = messages.where((m) => m.id == messageId).firstOrNull;

    if (displayingIAM == messageId) { return; }

    displayingIAM = messageId;

    if (message != null && appContext != null && appContext.mounted && message.type == InAppMessageType.alert) {
      List<TextButton> buttons = [];

      setInAppMessageAsSeen(messageId);

      for (var button in message.buttons) {
        buttons.add(
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(appContext).textTheme.labelLarge),
            child: Text(button.label),
            onPressed: () {
              executeButtonAction(button.id, message.id);
              Navigator.of(appContext).pop();
            }
        ));
      }

      showDialog(context: appContext, builder: (x) => AlertDialog(
        title: Text(message.title),
        content: Text(message.body),
        actions: buttons
      ));
    }
    else {
      await displayNotificationInternal(messageId, templateId: templateId);
    }
  }

  Future<void> displayNotificationInternal(String notificationId, {String? templateId = ''}) async {
    try {
      await methodChannel.invokeMethod('displayNotification', { 'notificationId': notificationId, 'templateId': templateId  });
    } 
    on PlatformException catch(exception) {
      log.severe('Exception when displaying the notification: ${exception.message}');
    }
  }
}