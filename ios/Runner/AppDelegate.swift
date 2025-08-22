import UIKit
import Flutter
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()
    
    // Configure Facebook SDK
    ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
    )
    
    // Register for remote notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // Setup method channels
    setupMethodChannels(controller: controller)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupMethodChannels(controller: FlutterViewController) {
    let nativeChannel = FlutterMethodChannel(name: "com.instanova.app/native",
                                              binaryMessenger: controller.binaryMessenger)
    
    nativeChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "getDeviceInfo":
        self.getDeviceInfo(result: result)
      case "getBatteryLevel":
        self.getBatteryLevel(result: result)
      case "requestCameraPermission":
        self.requestCameraPermission(result: result)
      case "requestPhotoLibraryPermission":
        self.requestPhotoLibraryPermission(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }
  
  private func getDeviceInfo(result: FlutterResult) {
    let device = UIDevice.current
    let deviceInfo: [String: Any] = [
      "name": device.name,
      "model": device.model,
      "systemName": device.systemName,
      "systemVersion": device.systemVersion,
      "identifierForVendor": device.identifierForVendor?.uuidString ?? "",
      "localizedModel": device.localizedModel
    ]
    result(deviceInfo)
  }
  
  private func getBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == .unknown {
      result(FlutterError(code: "UNAVAILABLE",
                          message: "Battery info unavailable",
                          details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }
  
  private func requestCameraPermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      DispatchQueue.main.async {
        result(granted)
      }
    }
  }
  
  private func requestPhotoLibraryPermission(result: @escaping FlutterResult) {
    PHPhotoLibrary.requestAuthorization { status in
      DispatchQueue.main.async {
        result(status == .authorized || status == .limited)
      }
    }
  }
  
  // Handle Google SignIn
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    var handled = false
    
    // Handle Google SignIn
    if url.scheme?.hasPrefix("com.googleusercontent.apps") ?? false {
      handled = GIDSignIn.sharedInstance.handle(url)
    }
    
    // Handle Facebook Login
    handled = handled || ApplicationDelegate.shared.application(
      app,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
    
    return handled
  }
  
  // Handle push notifications registration
  override func application(_ application: UIApplication,
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
