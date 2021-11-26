//
//  SettingsManager.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 24.11.2021.
//

import Foundation
import UIKit

enum ApplicationTheme: String, CaseIterable, CustomStringConvertible {
  case system = "System"
  case light = "Light"
  case dark = "Dark"

  var description: String {
    switch self {
    case .system:
      return R.string.localizable.themeSystem()
    case .light:
      return R.string.localizable.themeLight()
    case .dark:
      return R.string.localizable.themeDark()
    }
  }
}

class SettingsManager {
  var observer: NSKeyValueObservation?

  lazy var themeDidChangeHandler: (UserDefaults, NSKeyValueObservedChange<String?>) -> Void = { _, change in
    guard
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let sceneDelegate = windowScene.delegate as? SceneDelegate,
      let window = sceneDelegate.window,
      let newValue = change.newValue,
      let themeRawValue = newValue,
      let theme = ApplicationTheme(rawValue: themeRawValue)
    else { return }

    let interfaceStyle: UIUserInterfaceStyle
    switch theme {
    case .system:
      interfaceStyle = .unspecified
    case .light:
      interfaceStyle = .light
    case .dark:
      interfaceStyle = .dark
    }

    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
      window.overrideUserInterfaceStyle = interfaceStyle
    }, completion: nil)
  }

  init() {
    observer = UserDefaults.standard.observe(
      \.applicationTheme,
      options: [.initial, .new],
      changeHandler: themeDidChangeHandler
    )
  }

  deinit {
    observer?.invalidate()
  }
}
