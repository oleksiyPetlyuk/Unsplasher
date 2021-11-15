//
//  ShowImagePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation

protocol ShowImagePresentationLogic {
  func presentImage(response: ShowImage.GetImage.Response)
}

class ShowImagePresenter: ShowImagePresentationLogic {
  weak var viewController: ShowImageDisplayLogic?

  func presentImage(response: ShowImage.GetImage.Response) {
    let image = response.image
    let viewModel = ShowImage.GetImage.ViewModel(displayedImage: .init(
      urls: image.urls,
      owner: .init(name: image.owner.name, avatarURL: image.owner.avatarURL, profileURL: image.owner.profileURL),
      isFavourite: image.isFavourite
    ))

    viewController?.displayImage(viewModel: viewModel)
  }
}
