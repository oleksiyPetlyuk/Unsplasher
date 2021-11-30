//
//  ShowImagePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation
import UIKit

protocol ShowImagePresentationLogic {
  func presentImage(response: ScenesModels.Image.Fetch.Response)

  func presentAlert(response: ScenesModels.Alert.Response)

  func presentLoadingIndicator(response: ScenesModels.Loading.Response)
}

class ShowImagePresenter: ShowImagePresentationLogic {
  weak var viewController: ShowImageDisplayLogic?

  func presentImage(response: ScenesModels.Image.Fetch.Response) {
    guard let image = response.image else { return }

    var displayedOwner: ScenesModels.DisplayedImageOwner?

    if let owner = image.owner {
      displayedOwner = ScenesModels.DisplayedImageOwner(
        name: owner.name,
        avatar: owner.avatarURL,
        unsplashProfile: owner.unsplashProfileURL
      )
    }

    let displayedImage = ScenesModels.DisplayedImage(
      id: image.id,
      urls: image.urls,
      owner: displayedOwner,
      isFavorite: image.isFavorite,
      topic: image.topic
    )

    viewController?.displayImage(viewModel: .init(image: displayedImage))
  }

  func presentAlert(response: ScenesModels.Alert.Response) {
    let alert = ScenesModels.Alert.DataModel(
      title: response.title,
      message: response.message,
      actions: response.actions
    )

    viewController?.displayAlert(viewModel: .init(alert: alert))
  }

  func presentLoadingIndicator(response: ScenesModels.Loading.Response) {
    viewController?.displayLoadingIndicator(viewModel: .init(loadingIndicator: .init(isActive: response.isActive)))
  }
}
