import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var locationPermissionBridge: LocationPermissionBridge?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // Set up push notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "com.taybgo.driver/location_permissions",
        binaryMessenger: controller.binaryMessenger
      )
      locationPermissionBridge = LocationPermissionBridge(channel: channel)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}

private final class LocationPermissionBridge: NSObject, CLLocationManagerDelegate {
  private let channel: FlutterMethodChannel
  private var locationManager: CLLocationManager?
  private var pendingResult: FlutterResult?

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()

    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestAlwaysPermission":
      requestAlwaysPermission(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestAlwaysPermission(result: @escaping FlutterResult) {
    guard CLLocationManager.locationServicesEnabled() else {
      result("serviceDisabled")
      return
    }

    let status = currentStatus()
    switch status {
    case .authorizedAlways:
      result("authorizedAlways")
    case .denied, .restricted:
      result("denied")
    case .notDetermined, .authorizedWhenInUse:
      guard pendingResult == nil else {
        result(
          FlutterError(
            code: "permission_request_in_progress",
            message: "A location permission request is already running.",
            details: nil
          )
        )
        return
      }

      let manager = CLLocationManager()
      manager.delegate = self
      locationManager = manager
      pendingResult = result
      manager.requestAlwaysAuthorization()
    @unknown default:
      result("unknown")
    }
  }

  private func currentStatus() -> CLAuthorizationStatus {
    if #available(iOS 14.0, *) {
      return CLLocationManager().authorizationStatus
    }

    return CLLocationManager.authorizationStatus()
  }

  @available(iOS 14.0, *)
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    completeIfNeeded(with: manager.authorizationStatus)
  }

  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    completeIfNeeded(with: status)
  }

  private func completeIfNeeded(with status: CLAuthorizationStatus) {
    guard status != .notDetermined, let result = pendingResult else {
      return
    }

    switch status {
    case .authorizedAlways:
      result("authorizedAlways")
    case .authorizedWhenInUse:
      result("authorizedWhenInUse")
    case .denied, .restricted:
      result("denied")
    case .notDetermined:
      return
    @unknown default:
      result("unknown")
    }

    pendingResult = nil
    locationManager?.delegate = nil
    locationManager = nil
  }
}
