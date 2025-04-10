import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutterselligent_method_channel.dart';
import 'flutterselligent_constants.dart';
import 'flutterselligent.dart';

abstract class FlutterselligentPlatform extends PlatformInterface {
  /// Constructs a FlutterselligentPlatform.
  FlutterselligentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterselligentPlatform _instance = MethodChannelFlutterselligent();
  
  /// The default instance of [FlutterselligentPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterselligent].
  static FlutterselligentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterselligentPlatform] when
  /// they register themselves.
  static set instance(FlutterselligentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getVersionLib() {
    throw UnimplementedError('getVersionLib() has not been implemented.');
  }

  Future<String> getDeviceId() {
    throw UnimplementedError('getDeviceId() has not been implemented.');
  }

  Future<void> executePushAction() {
    throw UnimplementedError('executePushAction() has not been implemented.');
  }

  Future<void> applyLogLevel(LogLevel logLevel) {
    throw UnimplementedError('applyLogLevel() has not been implemented.');
  }

  Future<void> enableNotifications(bool enabled) {
    throw UnimplementedError('enableNotifications() has not been implemented.');
  }

  Future<void> registerForProvisionalRemoteNotification() {
    throw UnimplementedError('registerForProvisionalRemoteNotification() has not been implemented.');
  }

  Future<void> displayLastReceivedNotification() {
    throw UnimplementedError('displayLastReceivedNotification() has not been implemented.');
  }

  Future<void> displayLastReceivedRemotePushNotification({String? templateId = ''}) {
    throw UnimplementedError('displayLastReceivedRemotePushNotification() has not been implemented.');
  }

  Future<RemoteNotificationData?> getLastRemotePushNotification() {
    throw UnimplementedError('getLastRemotePushNotification() has not been implemented.');
  }

  Future<void> enableInAppMessages(bool enabled) {
    throw UnimplementedError('enableInAppMessages() has not been implemented.');
  }

  Future<bool> areInAppMessagesEnabled() {
    throw UnimplementedError('areInAppMessagesEnabled() has not been implemented.');
  }

  Future<List<InAppMessageData>> getInAppMessages() {
    throw UnimplementedError('getInAppMessages() has not been implemented.');
  }
  
  Future<void> setInAppMessageAsSeen(String messageId) {
    throw UnimplementedError('setInAppMessageAsSeen() has not been implemented.');
  }

  Future<void> setInAppMessageAsUnseen(String messageId) {
    throw UnimplementedError('setInAppMessageAsUnseen() has not been implemented.');
  }

  Future<void> setInAppMessageAsDeleted(String messageId) {
    throw UnimplementedError('setInAppMessageAsDeleted() has not been implemented.');
  }

  Future<void> executeButtonAction(String buttonId, String messageId) {
    throw UnimplementedError('executeButtonAction() has not been implemented.');
  }

  Future<void> displayNotification(String notificationId, {String? templateId = ''}) {
    throw UnimplementedError('displayNotification() has not been implemented.');
  }

  Future<void> sendEvent(EventType type, String identifier, Map<Object?, Object?> data) {
    throw UnimplementedError('sendEvent() has not been implemented.');
  }

  Future<void> subscribeToEvents(List<String> events, {required Function(BroadcastEvent event) handle}) {
    throw UnimplementedError('subscribeToEvents() has not been implemented.');
  }
}