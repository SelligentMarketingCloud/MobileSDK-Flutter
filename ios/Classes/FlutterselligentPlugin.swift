import Flutter
import UIKit
import FlutterSelligentMobileSDK

public class FlutterselligentPlugin: NSObject, FlutterPlugin, FlutterSelligentEventHandlerProtocol {
    private var listeningEvents = false
    private var pendingEvents = [CustomEvent]()
    private static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        self.channel = FlutterMethodChannel(name: "flutterselligent", binaryMessenger: registrar.messenger())
        let instance = FlutterselligentPlugin()

        FlutterSelligent.eventDelegate = instance
        FlutterSelligent.subscribeToEvents([])
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        switch call.method {
            case "getVersionLib":
                result(FlutterSelligent.getVersionLib())
            case "getDeviceId":
                result(FlutterSelligent.getDeviceId())
            case "executePushAction":
                FlutterSelligent.executePushAction()
                result(true)
            case "applyLogLevel":
                FlutterSelligent.applyLogLevel([args!["logLevel"] as! Int])
                result(true)
            case "enableNotifications":
                FlutterSelligent.enableNotifications(args!["enabled"] as! Bool)
                result(true)
            case "registerForProvisionalRemoteNotification":
                FlutterSelligent.registerForProvisionalRemoteNotification()
                result(true)
            case "displayLastReceivedNotification":
                FlutterSelligent.displayLastReceivedNotification()
                result(true)
            case "displayLastReceivedRemotePushNotification":
                FlutterSelligent.displayLastReceivedRemotePushNotification(withTemplateId: args?["templateId"] as? String)
                result(true)
            case "getLastRemotePushNotification":
                result(FlutterSelligent.getLastRemotePushNotification())
            case "enableInAppMessages":
                FlutterSelligent.enable(inAppMessages: args!["enabled"] as! Bool)
                result(true)
            case "areInAppMessagesEnabled":
                result(FlutterSelligent.areInAppMessagesEnabled())
            case "getInAppMessages":
                result(FlutterSelligent.getInAppMessages())
            case "setInAppMessageAsSeen":
                result(FlutterSelligent.setInAppMessageAsSeen(args!["messageId"] as! String, seen: true))
            case "setInAppMessageAsUnseen":
                result(FlutterSelligent.setInAppMessageAsSeen(args!["messageId"] as! String, seen: false))
            case "setInAppMessageAsDeleted":
                result(FlutterSelligent.setInAppMessageAsDeleted(args!["messageId"] as! String))
            case "executeButtonAction":
                result(FlutterSelligent.executeButtonAction(args!["buttonId"] as! String, messageId: args!["messageId"] as! String))
            case "displayNotification":
                FlutterSelligent.displayNotification(args!["notificationId"] as! String, templateId: args?["templateId"] as? String)
                result(true)
            case "sendEvent":
                FlutterSelligent.sendEvent(args!["data"] as! [AnyHashable: Any], completion: {_,_ in })
                result(true)
            case "subscribeToEvents":
                FlutterSelligent.subscribeToEvents(args!["events"] as! [String])
                self.listeningEvents = true
                self.sendPendingEvents()
                result(true)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    public func sendBroadcastEvent(name: String, type: String, data: [AnyHashable : Any]?) {
        if self.listeningEvents {
            Self.channel!.invokeMethod("broadcastEvent", arguments: [
                "name": name,
                "data": data ?? "",
                "broadcastEventType": type
            ])
        }
        else {
            self.pendingEvents.append(CustomEvent(name: name, type: type, data: data))
        }
    }
    
    private func sendPendingEvents() {
        if self.pendingEvents.count == 0 { return }
        
        for event in self.pendingEvents {
            Self.channel!.invokeMethod("broadcastEvent", arguments: [
                "name": event.name,
                "data": event.data ?? "",
                "broadcastEventType": event.type
            ])
        }
        
        self.pendingEvents.removeAll()
    }
}
