//
//  ShowImagePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation

protocol ShowImagePresentationLogic {
  func presentImage(response: ScenesModels.Image.Fetch.Response)
}

class ShowImagePresenter: ShowImagePresentationLogic {
  weak var viewController: ShowImageDisplayLogic?

  func presentImage(response: ScenesModels.Image.Fetch.Response) {
    guard let image = response.image else { return }


    let imageOwner = ScenesModels.DisplayedOwner(
      name: image.owner.name,
      avatarURL: image.owner.avatarURL,
      profileURL: image.owner.profileURL
    )
    let displayedImage = ScenesModels.DisplayedImage(
      id: image.id,
      urls: image.urls,
      owner: imageOwner,
      isFavorite: image.isFavorite,
      topic: image.topic
    )

    viewController?.displayImage(viewModel: .init(image: displayedImage))
  }
}
