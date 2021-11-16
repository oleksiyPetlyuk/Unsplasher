//
//  ShowImageInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation
import UIKit

protocol ShowImageBusinessLogic {
  func getImage(request: ScenesModels.Image.Fetch.Request?)

  func openImageOwnerProfile(request: ScenesModels.Image.Fetch.Request?)

  func toggleFavorite(request: ScenesModels.Image.Update.Request?)
}

protocol ShowImageDataStore {
  // swiftlint:disable:next implicitly_unwrapped_optional
  var image: Image! { get set }
}

class ShowImageInteractor: ShowImageBusinessLogic, ShowImageDataStore {
  var presenter: ShowImagePresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: imagesStore)

  // swiftlint:disable:next implicitly_unwrapped_optional
  var image: Image!

  func getImage(request: ScenesModels.Image.Fetch.Request?) {
    guard let request = request else {
      presenter?.presentImage(response: .init(image: image))

      return
    }

    imagesWorker.fetchImage(with: request.id) { [weak self] image in
      guard let self = self else { return }

      self.presenter?.presentImage(response: .init(image: image))
    }
  }

  func openImageOwnerProfile(request: ScenesModels.Image.Fetch.Request?) {
    guard let request = request else {
      UIApplication.shared.open(image.owner.profileURL)

      return
    }

    imagesWorker.fetchImage(with: request.id) { image in
      guard let image = image else { return }

      UIApplication.shared.open(image.owner.profileURL)
    }
  }

  func toggleFavorite(request: ScenesModels.Image.Update.Request?) {
    guard let request = request else {
      image.isFavorite.toggle()
      presenter?.presentImage(response: .init(image: image))

      return
    }

    imagesWorker.fetchImage(with: request.id) { [weak self] image in
      guard let self = self, let image = image else { return }

      image.isFavorite.toggle()
      self.presenter?.presentImage(response: .init(image: image))
    }
  }
}
