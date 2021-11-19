//
//  FavoritesInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import Foundation
import RealmSwift

protocol FavoritesBusinessLogic {
  func fetchFavorites()

  func fetchImage(request: ScenesModels.Image.Fetch.Request, completion: @escaping (ScenesModels.Image.Fetch.Response) -> Void)
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

  func fetchImage(request: ScenesModels.Image.Fetch.Request, completion: @escaping (ScenesModels.Image.Fetch.Response) -> Void) {
    imagesWorker.fetchImage(with: request.id) { image in
      completion(.init(image: image))
    }
  }
}
