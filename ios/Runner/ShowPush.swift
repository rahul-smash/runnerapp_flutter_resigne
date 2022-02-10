//
//  ShowPush.swift
//  Runner
//
//  Created by Jasmeet on 10/02/22.
//

import Foundation
import Flutter
import UIKit

public class SwiftSomeNamePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pushMethod", binaryMessenger: registrar.messenger())
    let instance = SwiftSomeNamePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

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
