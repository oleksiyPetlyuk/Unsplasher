//
//  SettingsPresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 23.11.2021.
//

import Foundation

protocol SettingsPresentationLogic {
  func presentSettings(response: Settings.Get.Response)
}

class SettingsPresenter: SettingsPresentationLogic {
  weak var viewController: SettingsDisplayLogic?

  func presentSettings(response: Settings.Get.Response) {
    viewController?.displaySettings(viewModel: .init(settings: response.settings))
  }
}
