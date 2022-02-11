import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,CLLocationManagerDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      LocationManager.shared.setupLocationManager()
      
      
      registerForRichNotifications()
      
      let controller:FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let locationChannel = FlutterMethodChannel(name: "ios/locationUpdate", binaryMessenger: controller.binaryMessenger)
      
      let pushChannel = FlutterMethodChannel(name: "pushMethod", binaryMessenger: controller.binaryMessenger)
      
      pushChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
          guard call.method == "pushParams" else {
              result(FlutterMethodNotImplemented)
              return
            }
          
          let argss = call.arguments as! NSArray
          if argss[0] as! Int == 1{
              let content = UNMutableNotificationContent()

                  content.title = "You have pending orders"
                 
                  content.sound = UNNotificationSound.default

                  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                  let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)

                  UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
          }
        })
      
      
      
      locationChannel.setMethodCallHandler({[weak self]
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
          guard call.method == "getLocationBackground" else {
              result(FlutterMethodNotImplemented)
              return
            }
            self?.receiveLocations(result: result)
          
        })
      
      //getLocationBackground
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func registerForRichNotifications() {

           UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                if granted {
                    print("Permission granted")
                } else {
                    print("Permission not granted")
                }
            }

            //actions defination
//            let action1 = UNNotificationAction(identifier: "action1", title: "Action First", options: [.foreground])
//            let action2 = UNNotificationAction(identifier: "action2", title: "Action Second", options: [.foreground])

            let category = UNNotificationCategory(identifier: "timerDone", actions: [], intentIdentifiers: [], options: [])

            UNUserNotificationCenter.current().setNotificationCategories([category])

        }
    
    private func receiveLocations(result: FlutterResult) {
     
       let loc =  LocationManager.shared.currentLocation
        
        var locArr:[Double] = []
        
        locArr.append(loc?.coordinate.longitude ?? 0.0)
        
        locArr.append(loc?.coordinate.latitude ?? 0.0)
        
        result(locArr)
    }
    
     func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "pushMethod", binaryMessenger: registrar.messenger())
      let instance = SwiftSomeNamePlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
    }

   func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

      // flutter cmds dispatched on iOS device :
      if call.method == "pushParams" {

        guard let args = call.arguments else {
          return
        }
        if let myArgs = args as? [String: Any],
           let someInfo1 = myArgs["reminderCount"] as? Int
          {
          result("Params received on iOS = \(someInfo1)")
        } else {
          result(FlutterError(code: "-1", message: "iOS could not extract " +
             "flutter arguments in method: (sendParams)", details: nil))
        }
      }  else {
        result(FlutterMethodNotImplemented)
      }
    }
    
}
