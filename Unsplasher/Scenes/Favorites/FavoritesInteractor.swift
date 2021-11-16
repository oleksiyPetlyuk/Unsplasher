//
//  FavoritesInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import Foundation

protocol FavoritesBusinessLogic {
  func fetchFavorites()

  func fetchImage(request: ScenesModels.Image.Fetch.Request) -> ScenesModels.Image.Fetch.Response
}

protocol FavoritesDataStore {
  var images: [Image]? { get }
}

class FavoritesInteractor: FavoritesBusinessLogic, FavoritesDataStore {
  var presenter: FavoritesPresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: imagesStore)
  var images: [Image]?

  func fetchFavorites() {
    imagesWorker.fetchFavoriteImages { [weak self] images in
      guard let self = self else { return }

      self.images = images

      self.presenter?.presentFavorites(response: .init(images: images))
    }
  }

  func fetchImage(request: ScenesModels.Image.Fetch.Request) -> ScenesModels.Image.Fetch.Response {
    guard let images = images else {
      return .init(image: nil)
    }

    let image = images.first { $0.id == request.id }

    return .init(image: image)
  }
}
