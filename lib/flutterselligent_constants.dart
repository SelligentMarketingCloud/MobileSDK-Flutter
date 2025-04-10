enum LogLevel {
  none(50),
  info(51),
  warning(52),
  error(53),
  httpCall(54),
  all(56);

  final int value;
  
  const LogLevel(this.value);

  static int getByType(LogLevel type) {
    return LogLevel.values.firstWhere((x) => x == type).value;
  }

  static LogLevel getByValue(int value) {
    return LogLevel.values.firstWhere((x) => x.value == value);
  }
}

enum InAppMessageType {
  unknown(-2),
  hidden(-1),
  alert(0),
  html(1),
  url(2),
  image(3),
  map(4),
  passbook(5);

  final int value;
  
  const InAppMessageType(this.value);

  static int getByType(InAppMessageType type) {
    return InAppMessageType.values.firstWhere((x) => x == type).value;
  }

  static InAppMessageType getByValue(int value) {
    return InAppMessageType.values.firstWhere((x) => x.value == value);
  }
}

enum RemoteMessagesDisplayType {
  automatic(20),
  none(21),
  notification(22);

  final int value;
  
  const RemoteMessagesDisplayType(this.value);

  static int getByType(RemoteMessagesDisplayType type) {
    return RemoteMessagesDisplayType.values.firstWhere((x) => x == type).value;
  }

  static RemoteMessagesDisplayType getByValue(int value) {
    return RemoteMessagesDisplayType.values.firstWhere((x) => x.value == value);
  }
}

enum EventType {
  register(90),
  unregister(91),
  login(92),
  logout(93),
  custom(94);

  final int value;
  
  const EventType(this.value);

  static int getByType(EventType type) {
    return EventType.values.firstWhere((x) => x == type).value;
  }

  static EventType getByValue(int value) {
    return EventType.values.firstWhere((x) => x.value == value);
  }
}

enum NotificationButtonType {
  unknown(100),
  phoneCall(101),
  sms(102),
  mail(103),
  browser(104),
  openApp(105),
  rateApp(106),
  broadcastEvent(107),
  passbook(111),
  deeplink(112),
  simple(113);

  final int value;
  
  const NotificationButtonType(this.value);

  static int getByType(NotificationButtonType type) {
    return NotificationButtonType.values.firstWhere((x) => x == type).value;
  }

  static NotificationButtonType getByValue(int value) {
    return NotificationButtonType.values.firstWhere((x) => x.value == value);
  }
}

enum BroadcastEventType {
  buttonClick('ButtonClicked'),
  receivedIAM('ReceivedInAppMessage'),
  displayNotification('WillDisplayNotification'),
  dismissNotification('WillDismissNotification'),
  receiveDeviceId('ReceivedDeviceId'),
  receivedGcmToken('ReceivedGCMToken'),
  receivedNotification('ReceivedRemoteNotification'),
  universalLink('UniversalLinkExecuted'),
  customEvent('TriggeredCustomEvent'),
  displayingIAM('DisplayingInAppMessage');

  final String value;
  
  const BroadcastEventType(this.value);

  static String getByType(BroadcastEventType type) {
    return BroadcastEventType.values.firstWhere((x) => x == type).value;
  }

  static BroadcastEventType? getByValue(String value) {
    return BroadcastEventType.values.firstWhere((x) => x.value == value);
  }
}