//
//  ImagesWorker.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation
import SwiftUI
import RealmSwift

protocol ImagesStoreProtocol {
  func observeImages(observeHandler: @escaping (RealmCollectionChange<Results<Image>>) -> Void, completion: @escaping (NotificationToken?) -> Void)

  func observeImage(with id: Image.ID, observeHandler: @escaping (ObjectChange<Image>) -> Void) -> NotificationToken?

  func fetchFavorites(completion: @escaping (Result<[Image], Error>) -> Void)

  func fetchImage(with id: Image.ID, completion: @escaping (Result<Image?, Error>) -> Void)

  func updateImage(with id: Image.ID, set field: String, equalTo newValue: Any?)
}

class ImagesWorker {
  var imagesStore: ImagesStoreProtocol

  init(imagesStore: ImagesStoreProtocol) {
    self.imagesStore = imagesStore
  }

  func observeFeed(observeHandler: @escaping (RealmCollectionChange<Results<Image>>) -> Void, completion: @escaping (NotificationToken?) -> Void) {
    imagesStore.observeImages(observeHandler: observeHandler) { token in
      completion(token)
    }
  }

  func observeImage(with id: Image.ID, observeHandler: @escaping (ObjectChange<Image>) -> Void) -> NotificationToken? {
    return imagesStore.observeImage(with: id, observeHandler: observeHandler)
  }

  func fetchFavoriteImages(completion: @escaping ([Image]) -> Void) {
    imagesStore.fetchFavorites { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let images):
        completion(images)
      }
    }
  }

  func fetchImage(with id: Image.ID, completion: @escaping (Image?) -> Void) {
    imagesStore.fetchImage(with: id) { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let image):
        completion(image)
      }
    }
  }

  func updateImage(with id: Image.ID, set field: String, equalTo newValue: Any?) {
    imagesStore.updateImage(with: id, set: field, equalTo: newValue)
  }

  func toggleFavorite(for id: Image.ID) {
    fetchImage(with: id) { [weak self] image in
      guard let self = self, let image = image else { return }

      self.updateImage(with: image.id, set: "isFavorite", equalTo: !image.isFavorite)
    }
  }
}
