import Flutter
import UIKit
import CoreLocation

/// FlutterPrakashCorePlugin — extensible native bridge for iOS.
public class FlutterPrakashCorePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_prakash_core",
      binaryMessenger: registrar.messenger()
    )
    let instance = FlutterPrakashCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS \(UIDevice.current.systemVersion)")
    case "getDeviceModel":
      result("\(UIDevice.current.model) \(UIDevice.current.systemName)")
    case "getCurrentLocation":
      result(reportLastKnownLocation())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Returns the last known coordinate as a `"lat,lng"` string, or
  /// `"unavailable"` when Core Location isn't authorized with a recent fix.
  private func reportLastKnownLocation() -> String {
    let status = CLLocationManager.authorizationStatus()
    guard status == .authorizedWhenInUse || status == .authorizedAlways else {
      return "unavailable"
    }
    let manager = CLLocationManager()
    guard let location = manager.location else {
      return "unavailable"
    }
    return "\(location.coordinate.latitude),\(location.coordinate.longitude)"
  }
}
