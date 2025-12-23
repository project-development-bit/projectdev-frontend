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

    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      installSplashOverlay(on: flutterViewController)
      registerSplashChannel(with: flutterViewController)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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

    let overlay = UIView(frame: flutterViewController.view.bounds)
    overlay.translatesAutoresizingMaskIntoConstraints = false

    // Background image (matches LaunchScreen.storyboard: LaunchBackground)
    let bg = UIImageView(image: UIImage(named: "LaunchBackground"))
    bg.translatesAutoresizingMaskIntoConstraints = false
    bg.contentMode = .scaleToFill

    // Center logo (matches LaunchScreen.storyboard: LaunchImage)
    let logo = UIImageView(image: UIImage(named: "LaunchImage"))
    logo.translatesAutoresizingMaskIntoConstraints = false
    logo.contentMode = .center

    overlay.addSubview(bg)
    overlay.addSubview(logo)

    flutterViewController.view.addSubview(overlay)
    NSLayoutConstraint.activate([
      overlay.leadingAnchor.constraint(equalTo: flutterViewController.view.leadingAnchor),
      overlay.trailingAnchor.constraint(equalTo: flutterViewController.view.trailingAnchor),
      overlay.topAnchor.constraint(equalTo: flutterViewController.view.topAnchor),
      overlay.bottomAnchor.constraint(equalTo: flutterViewController.view.bottomAnchor),

      bg.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
      bg.trailingAnchor.constraint(equalTo: overlay.trailingAnchor),
      bg.topAnchor.constraint(equalTo: overlay.topAnchor),
      bg.bottomAnchor.constraint(equalTo: overlay.bottomAnchor),

      logo.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
      logo.trailingAnchor.constraint(equalTo: overlay.trailingAnchor),
      logo.topAnchor.constraint(equalTo: overlay.topAnchor),
      logo.bottomAnchor.constraint(equalTo: overlay.bottomAnchor),
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
