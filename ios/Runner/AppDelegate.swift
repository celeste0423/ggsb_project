import UIKit
import Flutter

import ManagedSettings
import DeviceActivity
import FamilyControls
import SwiftUI

var globalMethodCall = ""

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //local notification 설정
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    //screentime 설정
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let METHOD_CHANNEL_NAME = "flutter_screentime"
      // FlutterMethodChannel
      let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller as! FlutterBinaryMessenger)

//      @StateObject var model = MyModel.shared
//      @StateObject var store = ManagedSettingsStore()
      methodChannel.setMethodCallHandler {
          (call: FlutterMethodCall, result: @escaping FlutterResult) in
          Task {
              print("Task")
              do {
                  if #available(iOS 16.0, *) {
                      print("try requestAuthorization")
                      try await AuthorizationCenter.shared.requestAuthorization(for: FamilyControlsMember.individual)
                      print("requestAuthorization success")
                      switch AuthorizationCenter.shared.authorizationStatus {
                      case .notDetermined:
                          print("not determined")
                      case .denied:
                          print("denied")
                      case .approved:
                          print("approved")
                      @unknown default:
                          break
                      }
                  } else {
                      // Fallback on earlier versions
                  }
              } catch {
                  print("Error requestAuthorization: ", error)
              }
          }
          
          func discourageAllApps() {
                  // FamilyControls의 ShieldSettings를 사용하여 모든 앱을 discourage
                  let store = ManagedSettingsStore()
              store.shield.applicationCategories = .all()
              store.shield.webDomainCategories = .all()
              }
          func encourageAllApps() {
                  // FamilyControls의 ShieldSettings를 사용하여 모든 앱을 encourage
                  let store = ManagedSettingsStore()
              store.clearAllSettings()
              }
          
          switch call.method {
          case "allAppsDiscourage":
              globalMethodCall = "allAppsDiscourage"
              discourageAllApps()
              print("allAppsDiscourage")
              result(nil)
              
          case "allAppsEncourage":
              globalMethodCall = "allAppsEncourage"
              encourageAllApps()
              print("allAppsEncourage")
              result(nil)
              
//          case "selectAppsToDiscourage":
//              globalMethodCall = "selectAppsToDiscourage"
//              let vc = UIHostingController(rootView: ContentView()
//                  .environmentObject(model)
//                  .environmentObject(store))
//              controller.present(vc, animated: false, completion: nil)
//
//              print("selectAppsToDiscourage")
//              result(nil)
//          case "selectAppsToEncourage":
//              globalMethodCall = "selectAppsToEncourage"
//              let vc = UIHostingController(rootView: ContentView()
//                  .environmentObject(model)
//                  .environmentObject(store))
//              controller.present(vc, animated: false, completion: nil)
//
//              print("selectAppsToEncourage")
//              result(nil)
          default:
              print("no method")
              result(FlutterMethodNotImplemented)
          }
      }
      
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
