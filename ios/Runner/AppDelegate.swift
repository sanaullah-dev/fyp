import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyCLbJLS9F81c-2Qu1WcztJ2LdO10MgVCvk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
