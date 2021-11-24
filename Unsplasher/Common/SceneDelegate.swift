//
//  SceneDelegate.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 02.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow? {
    didSet {
      settingsManager = .init()
    }
  }

  var settingsManager: SettingsManager?
}
