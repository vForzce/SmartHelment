import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
     let dict = NSDictionary(contentsOfFile: path),
     let apiKey = dict["GoogleMapsApiKey"] as? String {
    GMSServices.provideAPIKey(apiKey)
  }
}
