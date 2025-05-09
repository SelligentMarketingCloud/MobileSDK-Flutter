# Flutter – Using the SDK

## Foreword

Copyright

The contents of this manual cover material copyrighted by Marigold. Marigold reserves all intellectual property rights on the manual, which should be treated as confidential information as defined under the agreed upon software licence/lease terms and conditions.

The use and distribution of this manual is strictly limited to authorised users of the Marigold Interactive Marketing Software (hereafter the "Software") and can only be used for the purpose of using the Software under the agreed upon software licence/lease terms and conditions. Upon termination of the right to use the Software, this manual and any copies made must either be returned to Marigold or be destroyed, at the latest two weeks after the right to use the Software has ended.

With the exception of the first sentence of the previous paragraph, no part of this manual may be reprinted or reproduced or distributed or utilised in any form or by any electronic, mechanical or other means, not known or hereafter invented, included photocopying and recording, or in any information storage or retrieval or distribution system, without the prior permission in writing from Marigold.

Marigold will not be responsible or liable for any accidental or inevitable damage that may result from unauthorised access or modifications.

User is aware that this manual may contain errors or inaccuracies and that it may be revised without advance notice. This manual is updated frequently.

Marigold welcomes any recommendations or suggestions regarding the manual, as it helps to continuously improve the quality of our products and manuals.

## Table of Contents

- [Flutter – Using the SDK](#flutter--using-the-sdk)
  - [Foreword](#foreword)
  - [Table of Contents](#table-of-contents)
  - [Working with the `selligent.json`](#working-with-the-selligentjson)
  - [Push notifications](#push-notifications)
    - [Rich Push Notifications](#rich-push-notifications)
      - [Universal Linking - iOS](#universal-linking---ios)
    - [Notification helper methods](#notification-helper-methods)
      - [Disable Marigold Engage Push Notifications](#disable-marigold-engage-push-notifications)
      - [Display last remote notification](#display-last-remote-notification)
      - [Display last remote notification content](#display-last-remote-notification-content)
      - [Retrieve last remote notification](#retrieve-last-remote-notification)
    - [Broadcasts](#broadcasts)
  - [In-App Messages](#in-app-messages)
    - [Display IAM](#display-iam)
      - [IAM Customization - Android](#iam-customization---android)
      - [IAM Customization - iOS](#iam-customization---ios)
    - [IAM Helper methods](#iam-helper-methods)
  - [Events](#events)
  - [Miscellaneous](#miscellaneous)
    - [Get lib version](#get-lib-version)
    - [Get device id](#get-device-id)
  - [Constants](#constants)
    - [ClearCacheIntervalValue](#clearcacheintervalvalue)
    - [InAppMessageType](#inappmessagetype)
    - [InAppMessageRefreshType](#inappmessagerefreshtype)
    - [RemoteMessagesDisplayType](#remotemessagesdisplaytype)
    - [LogLevel](#loglevel)
    - [EventType](#eventtype)
    - [NotificationButtonType](#notificationbuttontype)
    - [BroadcastEventType](#broadcasteventtype)

## Working with the `selligent.json`

The following properties can be used in the `selligent.json` to further configure the behaviour of the native SDKs.

> The values should be relevant to your configuration. There are parameters that can only be used on a specific platform, but can be set and will be ignored in the other platform.

| Property                                    | Type | Description |
| ------------------------------------------- | ------ | ------- |
| url                                         | string | The Marigold Engage webservice url to be used to integrate with your Marigold Engage platform |
| clientId                                    | string | The Marigold Engage client id to be used to integrate with your Marigold Engage platform |
| privateKey                                  | string | The Marigold Engage private key to be used to integrate with your Marigold Engage platform |
| interceptSelligentUniversalLinks            | boolean| (iOS Only) Optin to customly handle the execution of universal links coming from a Push/IAM [more information](#universal-linking---ios) |
| clearCacheIntervalValue                     | [enum](#clearcacheintervalvalue) | How much time the SDK will keep things in cache |  
| inAppMessageRefreshType                     | [enum](#inappmessagerefreshtype) | How often the SDK will check for new inapp messages |
| remoteMessageDisplayType                    | [enum](#remotemessagesdisplaytype) | The behaviour when receiving a push notification with the app in foreground |
| appGroupId                                  | string |(iOS Only) The appgroup id necessary for the correct communication between the app and the app extensions |
| shouldClearBadge                            | boolean | (iOS Only) Whether or not, clicking a push notification should reset the badge number |
| shouldDisplayRemoteNotification             | boolean | (iOS Only) Whether or not, the SDK should try to display the content linked to a push message (usually, inapp messages) or it will be handled customly
| enableiOSLogging                            | [enum](#loglevel) | Log level used since the app launch |
| enableAndroidLogging                        | boolean | (Android Only) Whether or not, the SDK logging will be enabled since the app launch |
| doNotListenToThePush                        | boolean | (Android Only) Whether or not, the SDK will listen for pushs from google |
| doNotFetchTheToken                          | boolean | (Android Only) Whether or not, the SDK will listen for push tokens from google |
| loadCacheAsynchronously                     | boolean | (Android Only) Whether or not, the SDK load the cache asynchronously |
| fullyQualifiedNotificationActivityClassName | string | (Android Only) The activity that will be opened after clicking in any push notification |
| notificationSmallIcon                       | string | (Android Only) Icon name, for the [small icon of push notifications](https://developer.android.com/guide/topics/resources/drawable-resource#BitmapFile) |
| notificationLargeIcon                       | string | (Android Only) Icon name, for the [large icon of push notifications](https://developer.android.com/guide/topics/resources/drawable-resource#BitmapFile) |
| notificationIconColor                       | string | (Android Only) A hex color code to customize the notification icon in push notifications |
| notificationChannelId                       | string | (Android Only) The channel id used by the push notifications received |
| notificationChannelName                     | string | (Android Only) The channel name used by the push notifications received |
| notificationChannelDescription              | string | (Android Only) The channel description used by the push notifications received |

## Push notifications

Follow the [iOS](https://github.com/SelligentMarketingCloud/MobileSDK-iOS/tree/master/Documentation#create-an-apns-key) & [Android](https://github.com/SelligentMarketingCloud/MobileSDK-Android/tree/master/Documentation#creating-an-application) native SDKs guides in order to optin for push notifications in Apple & Google.

**For Android**, if targeting API level 33 and above:

1. Add the following line to AndroidManifest.xml:

    ```xml
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    ```

2. Add this native code to request the push permission and let the SDK know when it is accepted, and display the push notifications, in the activity where you want to:

    ```kotlin
    import android.Manifest
    import android.content.pm.PackageManager
    import android.os.Build

    import androidx.core.app.ActivityCompat
    import androidx.core.content.ContextCompat

    import io.flutter.embedding.android.FlutterActivity
    import com.selligent.flutterselligent.FlutterselligentPlugin

    object SelligentConstants {
        const val NOTIFICATION_PERMISSION_REQUEST_CODE = 1111
    }

    class MainActivity : FlutterActivity() {
        override fun onStart() {
            super.onStart();

            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.S_V2) {
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), SelligentConstants.NOTIFICATION_PERMISSION_REQUEST_CODE)
                }
            }
        }

        override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)

            if (requestCode == SelligentConstants.NOTIFICATION_PERMISSION_REQUEST_CODE && grantResults.isNotEmpty() 
                && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                FlutterselligentPlugin.INSTANCE.enableNotifications()
            }
        }

        override fun onNewIntent(intent: Intent) {
            super.onNewIntent(intent)

            FlutterselligentPlugin.INSTANCE.onNewIntent(intent)
        }

        override fun onResume() {
            super.onResume()

            FlutterselligentPlugin.INSTANCE.onNewIntent(intent, activity)
        }

        override fun onPause() {
            super.onPause()

            FlutterselligentPlugin.INSTANCE.onPause()
        }
    }
    ```

**For iOS**:

1. For push notifications you need to delegate some of the `AppDelegate` methods to the SDK:

    ```swift
    import Flutter
    import UIKit
    import FlutterSelligentMobileSDK

    @main
    @objc class AppDelegate: FlutterAppDelegate {
        override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            UNUserNotificationCenter.current().delegate = self
            
            GeneratedPluginRegistrant.register(with: self)

            FlutterSelligent.configureWithLaunchOptions(launchOptions ?? [:])

            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            FlutterSelligent.didReceiveNotificationResponse(response, withCompletionHandler: completionHandler)
        }

        override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            FlutterSelligent.willPresentNotification(notification, withCompletionHandler: completionHandler)
        }

        override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            FlutterSelligent.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        }
        
        override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
            FlutterSelligent.didFailToRegisterForRemoteNotificationsWithError(error)
        }
    }
    ```

2. Follow section [**Create an APNS Key**](https://github.com/SelligentMarketingCloud/MobileSDK-iOS/tree/master/Documentation#apns_key), of the native documentation.

3. Somewhere in your Flutter app (normally done as soon as possible but can also be done when certain page is reached), you will need to call `Flutterselligent().enableNotifications()` to prompt the user for the push notification permission or the `Flutterselligent().registerForProvisionalRemoteNotification()` (This option is only available for iOS 12+) if you want to get a provisional permission before asking the user for the normal one, and `Flutterselligent().executePushAction(navigatorKey)` after all the initializations to tell the SDK that the flutter UI is ready to handle the push click.

    ```dart
    import 'package:flutterselligent/flutterselligent.dart';
    import 'package:flutterselligent/flutterselligent_constants.dart';

    final navigatorKey = GlobalKey<NavigatorState>();
    final flutterSelligent = Flutterselligent();

    flutterSelligent.enableNotifications(true);
    flutterSelligent.executePushAction(navigatorKey);

    // Navigator key must be part of your MaterialApp
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            ...
    ```

### Rich Push Notifications

**For iOS**, you will need to implement notification extensions and set the `appGroupId` in the `selligent.json` file.
Import the native extensions SDK in your app's podfile, create targets for your extensions:

```pod
target 'ServiceExtension' do
  use_frameworks!

  pod 'SelligentMobileSDK/FrameworkExtension', '3.8.6'
end

target 'ContentExtension' do
  use_frameworks!

  pod 'SelligentMobileSDK/FrameworkExtension', '3.8.6'
end
```

Run `pod update` in your ios folder.
Then, follow the [native iOS SDK documentation](https://github.com/SelligentMarketingCloud/MobileSDK-iOS/edit/master/Documentation/README.md#notification-extensions).
Make sure the minimum deployment target of your extensions is the same as your main app's one.
Go to your project's main app target  `Build Phases`, reorder the phases so the `[CP] Embed Pods Frameworks` is the last one and the `Thin Binary` is right above it.

#### Universal Linking - iOS

By default, universal links in a button from a Push/IAM will open the default browser, to avoid this and catch them on the App and apply any logic you want, you will need to add a property `interceptSelligentUniversalLinks` in the `selligent.json` with `true` as value.

You can listen to the event `BroadcastEventType.universalLink` through the `flutterSelligent.subscribeToEvents` function, the event will get triggered when a `deeplink` button type is defined in Marigold Engage (whose URL scheme is `http` or `https`).

```dart
flutterSelligent.subscribeToEvents([], handle: (event) {
    if (event.type == BroadcastEventType.universalLink) {
        var eventData = event.data as UniversalLinkData;
        // Do something with eventData.url
    }
});
```

### Notification helper methods

#### Disable Marigold Engage Push Notifications

You can enable or disable Marigold Engage push notifications (not all push notifications for your app) by calling `flutterSelligent.enableNotifications` anytime you want (do note that for iOS, the first call to this method will prompt the user for the push permission).

```dart
flutterSelligent.enableNotifications(true)
flutterSelligent.enableNotifications(false)
```

#### Display last remote notification

If you want to display the last received push notification you can call `flutterSelligent.displayLastReceivedNotification`.

```dart
flutterSelligent.displayLastReceivedNotification()
```

#### Display last remote notification content

If you want to display the last received push notification content (usually an inapp message) you can call `flutterSelligent.displayLastReceivedRemotePushNotification`. If the last push didn't have any content attached (just a simple push) then nothing will happen.

```dart
flutterSelligent.displayLastReceivedRemotePushNotification()
```

#### Retrieve last remote notification

You can get the last received push notification banner details by calling `flutterSelligent.getLastRemotePushNotification`.

```dart
var notification = await flutterSelligent.getLastRemotePushNotification();
// Do something with notification?.id or notification?.title
```

### Broadcasts

You can subscribe to `BroadcastEventType.buttonClick`, `BroadcastEventType.receivedIAM`, `BroadcastEventType.displayNotification`, `BroadcastEventType.dismissNotification`, `BroadcastEventType.receiveDeviceId`, `BroadcastEventType.receivedGcmToken`, `BroadcastEventType.receivedNotification`, `BroadcastEventType.universalLink`, `BroadcastEventType.customEvent` and `BroadcastEventType.displayingIAM` events through the `flutterSelligent.subscribeToEvents`.                                                                 | Additional data embedded to the button   |

```dart
flutterSelligent.subscribeToEvents([], handle: (event) {
    if (event.type == BroadcastEventType.buttonClick) {
        var buttonData = event.data as ButtonData;
    }
    else if (event.type == BroadcastEventType.receivedIAM) {
        var iamData = event.data as InAppMessageEventListData;
    }
    else if (event.type == BroadcastEventType.displayNotification) {
    }
    else if (event.type == BroadcastEventType.dismissNotification) {
    }
    else if (event.type == BroadcastEventType.receiveDeviceId) {
        var deviceIdData = event.data as DeviceIdData;
    }
    else if (event.type == BroadcastEventType.receivedGcmToken) {
        var tokenData = event.data as GcmTokenData;
    }
    else if (event.type == BroadcastEventType.receivedNotification) {
        var notification = event.data as NotificationData;
    }
    else if (event.type == BroadcastEventType.universalLink) {
        var link = event.data as UniversalLinkData;
    }
    else if (event.type == BroadcastEventType.customEvent) {
        if (event.data == "myCustomEventName") {
        }
    }
    else if (event.type == BroadcastEventType.displayingIAM) {
        var message = event.data as InAppMessageEventData;
    }
});
```

## In-App Messages

To enable them all you need to do is to set the proper [inAppMessageRefreshType](#inappmessagerefreshtype) value in the `selligent.json`.

You can later call the `flutterSelligent.enableInAppMessages` function (if you want) to further optin/optout from the functionality.

```dart
flutterSelligent.enableInAppMessages(true);
flutterSelligent.enableInAppMessages(false);
```

### Display IAM

Use the subscription to the event `BroadcastEventType.receivedIAM` events through the `flutterSelligent.subscribeToEvents`, to know when new messages are received.
The response of the success callback is an object which contains information on the type of broadcast event and the data attached to it.

You can also call `flutterSelligent.getInAppMessages` anywhere in your App to get the list of the currently known IAM.

```dart
var inapps = await flutterSelligent.getInAppMessages();
```

To display any of these messages, you can call `Selligent.displayMessage`:

```dart
var inapps = await _flutterselligentPlugin.getInAppMessages();
await _flutterselligentPlugin.displayNotification(inapps.first.id);
```

#### IAM Customization - Android

On Android, if you want to customize the IAM styles, you can refer to the [native documentation](https://github.com/SelligentMarketingCloud/MobileSDK-Android/tree/master/Documentation#design-customization).
`Alert` IAM type is displayed by flutter `showDialog` and uses your material app theme.

#### IAM Customization - iOS

On iOS, if you want to customize the IAM styles, you can define the templates, to do so you will need to do it in the native part, in the `AppDelegate/didFinishLaunchingWithOptions` method by calling the `FlutterSelligent.setInAppMessageStylingTemplates` method.
`Alert` IAM type is displayed by flutter `showDialog` and uses your material app theme.

```swift
import SelligentMobileSDK

var styleOptions1 = SMInAppMessageStyleOptions()
styleOptions1.alertBackgroundColor = .red
var styleOptions2 = SMInAppMessageStyleOptions()
styleOptions1.alertBackgroundColor = .blue

var template1 = InAppMessageStylingTemplate(templateId: "1", styleOptions: styleOptions1)
var template2 = InAppMessageStylingTemplate(templateId: "2", styleOptions: styleOptions2)

FlutterSelligent.setInAppMessageStylingTemplates([template1, template2], defaultTemplateId: "1")
```

### IAM Helper methods

If you decide to display the IAM on your own (without `flutterSelligent.displayNotification`), listening for new messages with the `flutterSelligent.subscribeToEvents` and/or getting the full list with `flutterSelligent.getInAppMessages`. You will be able to build your own layout with the object provided from the mentioned functions and then you can use the helper methods described here to still push KPI statistics to the Marigold Engage platform:

- setInAppMessageAsSeen: sets an IAM as seen and sends the corresponding `Opened` event to the Marigold Engage platform

    ```dart
    flutterSelligent.setInAppMessageAsSeen(message.id);
    ```

- setInAppMessageAsUnseen: sets an IAM as unseen

    ```dart
    flutterSelligent.setInAppMessageAsUnseen(message.id);
    ```

- setInAppMessageAsDeleted: sets an IAM as deleted

    ```dart
    flutterSelligent.setInAppMessageAsDeleted(message.id);
    ```

- executeButtonAction: executes the action linked to an IAM button and sends the corresponding `Clicked` event to the Marigold Engage platform

    ```dart
    flutterSelligent.executeButtonAction(button.id, message.id);
    ```

## Events

Sending any set of data to the backend can be done with `flutterSelligent.sendEvent`.
For events of type `EventType.custom` the `data` parameter is mandatory.
For events of type `EventType.login`, `EventType.logout`, `EventType.register` and `EventType.unregister` the `identifier` parameter is mandatory.

```javascript
flutterSelligent.sendEvent(EventType.login, 'user@mail.com', {
    'description': 'this is some extra information concerning this event'
});

flutterSelligent.sendEvent(EventType.custom, '', {
    'description': 'this is some extra information concerning this event'
});
```

## Miscellaneous

### Get lib version

Returns the version of the installed native Marigold Engage SDK (string).

```dart
await flutterSelligent.getVersionLib();
```

### Get device id

Returns the currently known Marigold Engage device Id (string).

```dart
await flutterSelligent.getDeviceId();
```

## Constants

Add the following import to work with the constants:

```dart
import 'package:flutterselligent/flutterselligent_constants.dart';
```

### ClearCacheIntervalValue

Defines the interval value to clear the cache.

| Name        | Type   | Value | Description                                  |
| ----------- | ------ | ----- | -------------------------------------------- |
| auto        | number | 1     | Clear cache automatically (weekly)           |
| none        | number | 2     | Don't clear cache                            |
| day         | number | 3     | Clear cache daily                            |
| week        | number | 4     | Clear cache weekly                           |
| month       | number | 5     | Clear cache monthly                          |
| quarter     | number | 6     | Clear cache quarterly                        |

### InAppMessageType

Defines the type of the IAM.

| Name     | Type   | Value | Description                     |
| -------- | ------ | ----- | ------------------------------- |
| unknown  | number | -2    | In App message of unknown type  |
| hidden   | number | -1    | In App message of hidden type   |
| alert    | number | 0     | In App message of alert type    |
| html     | number | 1     | In App message of html type     |
| url      | number | 2     | In App message of url type      |
| image    | number | 3     | In App message of image type    |
| map      | number | 4     | In App message of map type      |
| passbook | number | 5     | In App message of passbook type |

### InAppMessageRefreshType

Defines how often the SDK must retrieve the IAM.

| Name           | Type   | Value | Description                        |
| -------------- | ------ | ----- | ---------------------------------- |
| none           | number | 10    | Don't fetch the IAM                |
| minute         | number | 11    | Refresh minutely (do not set this for production builds) |
| hour           | number | 12    | Refresh hourly                     |
| day            | number | 13    | Refresh weekly                     |

### RemoteMessagesDisplayType

Defines if and how remote messages must be displayed when the App is in foreground.

| Name         | Type   | Value | Description                             |
| ------------ | ------ | ----- | --------------------------------------- |
| automatic    | number | 20    | Display the IAM (if any) linked to the push, directly    |
| none         | number | 21    | Don't display anything        |
| notification | number | 22    | Display the push notification banner (default behaviour) |

### LogLevel

Defines the level of output of logging messages.

| Name      | Type   | Value | Description       |
| --------- | ------ | ----- | ----------------- |
| none      | number | 50    | Output nothing    |
| info      | number | 51    | Output info       |
| warning   | number | 52    | Output warning    |
| error     | number | 53    | Output error      |
| httpCall  | number | 54    | Output http calls |
| all       | number | 56    | Output all        |

### EventType

Defines the type of an event.

| Name            | Type   | Value | Description       |
| --------------- | ------ | ----- | ----------------- |
| register   | number | 90    | Used to send a register event to the server with the custom email/profile identifier of the user, with the purpose of linking the device to an user and optionally storing some data at Marigold Engage platform side. This event will create a new user in your Marigold Engage database, if none was found (you can use an alternate key/value field to search for the user, in the data object, since by default the `identifier` one will use the `MAIL` column in your Marigold Engage database). |
| unregister | number | 91    | Used to send an unregister event to the server with the custom email/profile identifier of the user, with the purpose of keeping track of a REGISTERED flag and optionally storing some data at Marigold Engage platform side (this event is not unlinking the user from the device (automatically), at the moment). |
| login      | number | 92    | Used to send a login event to the server with the custom email/profile identifier of the user, with the purpose of linking the device to an user and optionally storing some data at Marigold Engage platform side. This event will **NOT** create a new user in your Marigold Engage database, if none found. |
| logout     | number | 93    | Used to send a logout event to the server with the custom email/profile identifier of the user, with the purpose of keeping track of a LOGGED flag and optionally storing some data at Marigold Engage platform side (this event is not unlinking the user from the device (automatically), at the moment). |
| custom          | number | 94    | Used to send a custom event to the server, with the purpose of keeping track of storing some data at Marigold Engage platform side. |

### NotificationButtonType

Defines the type of buttons for notifications or inapp messages.

| Name                          | Type   | Value | Description                               |
| ----------------------------- | ------ | ----- | ----------------------------------------- |
| unknown                       | number | 100   | Unknown button type                       |
| phoneCall                     | number | 101   | Opens a phone call dialog                 |
| sms                           | number | 102   | Opens a new sms dialog                    |
| mail                          | number | 103   | Opens a new email dialog                  |
| browser                       | number | 104   | Opens an URL in the default device's browser |
| openApp                       | number | 105   | Opens an external App                     |
| rateApp                       | number | 106   | Opens a 'rate this app' dialog            |
| broadcastEvent                | number | 107   | Sends a custom broadcast to the App       |
| passbook                      | number | 111   | Opens a passbook URL                      |
| deeplink                      | number | 112   | Executes a deeplink                       |
| simple                        | number | 113   | Nothing done except forwarding the corresponding `Clicked` event to the Marigold Engage platform |

### BroadcastEventType

Defines the type of a broadcast event.

| Name                             | Type   | Value                      | Description                                           |
| -------------------------------- | ------ | -------------------------- | ----------------------------------------------------- |
| buttonClick                      | string | ButtonClicked              | A button was clicked                                  |
| receivedIAM                      | string | ReceivedInAppMessage       | An IAM has been received                              |
| displayNotification              | string | WillDisplayNotification    | A notification will be displayed                      |
| dismissNotification              | string | WillDismissNotification    | A notification will be dismissed                      |
| receiveDeviceId                  | string | ReceivedDeviceId           | A device id has been received                         |
| receivedGcmToken                 | string | ReceivedGCMToken           | A GCM token has been received (only on Android)       |
| receivedNotification             | string | ReceivedRemoteNotification | A remote notification has been received               |
| universalLink                    | string | UniversalLinkExecuted      | An universal link has been executed                   |
| customEvent                      | string | TriggeredCustomEvent       | A custom event has been triggered                     |
| displayingIAM                    | string | DisplayingInAppMessage     | An IAM is about to be displayed                       |
