import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var splashOverlay: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      installSplashOverlay(on: flutterViewController)
      registerSplashChannel(with: flutterViewController)
    }

    return didFinish
  }

  private func registerSplashChannel(with flutterViewController: FlutterViewController) {
    let channel = FlutterMethodChannel(name: "app.splash", binaryMessenger: flutterViewController.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "hide":
        self?.hideSplashOverlay(animated: true)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func installSplashOverlay(on flutterViewController: FlutterViewController) {
    guard splashOverlay == nil else { return }

    // Use the iOS launch screen directly so the debug overlay always matches
    // `LaunchScreen.storyboard` and can't go blank due to asset lookup.
    let launchStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
    let launchViewController = launchStoryboard.instantiateInitialViewController()
    let overlay = launchViewController?.view ?? UIView(frame: flutterViewController.view.bounds)
    overlay.translatesAutoresizingMaskIntoConstraints = false

    flutterViewController.view.addSubview(overlay)
    NSLayoutConstraint.activate([
      overlay.leadingAnchor.constraint(equalTo: flutterViewController.view.leadingAnchor),
      overlay.trailingAnchor.constraint(equalTo: flutterViewController.view.trailingAnchor),
      overlay.topAnchor.constraint(equalTo: flutterViewController.view.topAnchor),
      overlay.bottomAnchor.constraint(equalTo: flutterViewController.view.bottomAnchor),
    ])

    splashOverlay = overlay
  }

  private func hideSplashOverlay(animated: Bool) {
    guard let overlay = splashOverlay else { return }

    let remove = {
      overlay.removeFromSuperview()
      self.splashOverlay = nil
    }

    guard animated else {
      remove()
      return
    }

    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
      overlay.alpha = 0.0
    }, completion: { _ in
      remove()
    })
  }
}
