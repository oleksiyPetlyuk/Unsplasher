//
//  SettingsInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 23.11.2021.
//

import Foundation

protocol SettingsBusinessLogic {
  func getSettings()

  func changeTheme(request: Settings.ChangeTheme.Request)
}

class SettingsInteractor: SettingsBusinessLogic {
  var presenter: SettingsPresentationLogic?

  func getSettings() {
    let themeRawValue = UserDefaults.standard.string(forKey: "applicationTheme") ?? ApplicationTheme.system.rawValue
    let theme = ApplicationTheme(rawValue: themeRawValue) ?? .system
    let settings = Settings.SettingsData(theme: theme)

    presenter?.presentSettings(response: .init(settings: settings))
  }

  func changeTheme(request: Settings.ChangeTheme.Request) {
    UserDefaults.standard.set(request.theme.rawValue, forKey: "applicationTheme")

    getSettings()
  }
}
