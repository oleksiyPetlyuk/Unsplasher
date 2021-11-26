//
//  Alertable.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 26.11.2021.
//

import UIKit

protocol Alertable {
  func displayAlert(viewModel: ScenesModels.Alert.ViewModel)
}

extension UIViewController: Alertable {
  func displayAlert(viewModel: ScenesModels.Alert.ViewModel) {
    let alert = UIAlertController(
      title: viewModel.alert.title,
      message: viewModel.alert.message,
      preferredStyle: viewModel.alert.style
    )

    if let actions = viewModel.alert.actions {
      for action in actions {
        alert.addAction(action)
      }
    }

    present(alert, animated: true)
  }
}
