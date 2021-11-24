//
//  SettingsModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 23.11.2021.
//

import Foundation

// swiftlint:disable nesting
enum Settings {
  struct SettingsData {
    let theme: ApplicationTheme
  }

  struct ViewModel {
    let settings: SettingsData
  }

  enum Get {
    struct Response {
      let settings: SettingsData
    }
  }

  enum ChangeTheme {
    struct Request {
      let theme: ApplicationTheme
    }
  }
}
