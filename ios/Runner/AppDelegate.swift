import UIKit
import Flutter

enum ChannelName {
    static let twoWayName = "myapp/twoWay"
    static let channelName = "myapp/baseMethodChannel"
    static let eventName = "myapp/baseEventChannel"
}

enum CallMethod {
    static let initState = "initState"
    static let getToken = "getToken"
    static let deleteToken = "deleteToken"
    static let saveToken = "saveToken"
    static let updateToken = "updateToken"
    static let startBle = "startBle"
    static let startNfc = "startNfc"
    static let isNfcOk = "isNfcOk"
    static let dispose = "dispose"
    
 }
enum KolonbaseErrorCode {
  static let unavailable = "UNAVAILABLE"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // ------- start -------------
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }
      let twoWayMethodChannel = FlutterBasicMessageChannel(name: ChannelName.twoWayName, binaryMessenger: controller.binaryMessenger);
      let passKit = PassController();
      let keychainChannel = FlutterMethodChannel(name: ChannelName.channelName,
                                              binaryMessenger: controller.binaryMessenger)
    keychainChannel.setMethodCallHandler({

      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          
            let callMethod = call.method
            switch callMethod {
            case CallMethod.initState:
                passKit.initial()
                passKit.setChannel(twoWayMethodChannel)
                result(String("success"))
                return
            case CallMethod.getToken:
               
                var temp = passKit.getToken()
                if temp != nil {
                    result(temp!)
                }
        return result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                           message: "get token faild",
                                           details: nil))
            case CallMethod.deleteToken:
                passKit.deleteToken()
                result(String("success"))
                return
            case CallMethod.saveToken:
                if let token = call.arguments as? String{
                    print("id = \(token)")
                    passKit.saveToken(token)
                    result(String("success"))
                }
                return
            case CallMethod.updateToken:
                if let token = call.arguments as? String{
                    print("id = \(token)")
                    passKit.updateToken(token)
                    result(String("success"))
                }
                return
            case CallMethod.startBle:
                passKit.startBLE()
                result(String("success"))
                return
            case CallMethod.startNfc:
                passKit.startNFC()
                result(String("success"))
                return
            case CallMethod.dispose:
                passKit.dispose()
                result(String("success"))
                return
            case CallMethod.isNfcOk:
                passKit.isNfcOk()
                result(String("success"))
                return
            default:
                result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                          message: "call Method not match",
                                          details: nil))
            }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   
}



