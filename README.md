# Marigold Engage-Flutter (flutterselligent)

This module provides an API for the usage of the Marigold Engage Mobile SDKs in Flutter.

## Marigold Engage-Flutter Integration

This module supports the following SDK and tools:

| SDK                                                                            | Version |
| ------------------------------------------------------------------------------ |---------|
| [Android SDK](https://github.com/SelligentMarketingCloud/MobileSDK-Android)    | 4.7.0   |
| [iOS SDK](https://github.com/SelligentMarketingCloud/MobileSDK-iOS)            | 3.8.6   |
| Flutter                                                                        | 3.3.0   |
| Flutter SDK                                                                    | 3.7.0   |

## Installation

> Please refer to our [SDK full documentation](documentation/#flutter--using-the-sdk) for a step-by-step guide on how to use the SDK, after installation.

1. Run this command with Flutter

   ```shell
   flutter pub add flutterselligent
   ```

    Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

    To update to a newer version, you can run the following command

    ```shell
    flutter pub upgrade
    ```

2. Create a `selligent.json` file (name is case sensitive) in the root of the Flutter project (you can alternatively place it inside another folder or inside a `selligent` folder which will automatically be checked by the wrapper) with the following content:

   ```json
   {
     "url": "someMobilePushUrl",
     "clientId": "someClientId",
     "privateKey": "somePrivateKey",
     "fullyQualifiedNotificationActivityClassName": "com.some.project.MainActivity",
     "appGroupId": "group.yourgroupname",
     "enableiOSLogging": 56,
     "enableAndroidLogging": true
   }
   ```

> Check all the options that can be used in our [SDK full documentation](documentation/#working-with-the-selligentjson)

### iOS Specific installation

1. Drag and drop the `selligent.json` you created (or the full folder(s) containing it) to the Xcode project inside the `Copy Bundle Resources` in `Build phases` of your target:

    > Do not check the "copy if needed" option to make sure you only have to manage one selligent.json file

2. Start the SDK in the `AppDelegate`

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
            GeneratedPluginRegistrant.register(with: self)

            FlutterSelligent.configureWithLaunchOptions(launchOptions ?? [:])

            // OR
            // You can alternatively specify a different file name (without the extension) from where to load the Marigold Engage configs (defaults to 'selligent')
            // var customLaunchOptions = launchOptions ?? .init()
            // customLaunchOptions[.init(rawValue: "FLUTTER_SELLIGENT_JSON")] = "alternativeFileName"
            // customLaunchOptions[.init(rawValue: "FLUTTER_SELLIGENT_JSON")] = "selligent/alternativeFileName"
            // FlutterSelligent.configureWithLaunchOptions(customLaunchOptions)

            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    ```

### Android Specific installation

1. Create a Google application following the section **Creating a Google application** of the **Android - Using the SDK** pdf, and place the `google-services.json` file in the `android/app` folder.

2. Add the following in the `android/build.gradle.kts` file:

    ```groovy
    buildscript {
        repositories {
            google()
            mavenCentral()
        }
        dependencies {
            classpath("com.google.gms:google-services:4.4.0")
        }
    }
    ```

3. Add the following in the `android/app/build.gradle.kts` file (at the bottom):

   ```groovy
   apply(plugin = "com.google.gms.google-services")
   ```

4. Create a `MainApplication.kt` file next to the `MainActivity.kt` and configure the SDK (make sure the `android:name` in the `AndroidManifest.xml` points to `.MainApplication`):

    ```kotlin
    import android.app.Application;
    import com.selligent.flutterselligent.FlutterselligentPlugin
    import android.util.Log;

    class MainApplication : Application() {
        override fun onCreate() {
            super.onCreate()

            FlutterselligentPlugin.configure(this)
        }
    }
    ```

5. Enable `Buildconfig` in the `gradle.properties` at project level:

    ```groovy
    android.defaults.buildfeatures.buildconfig=true
    ```


