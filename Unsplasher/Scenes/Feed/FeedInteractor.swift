//
//  FeedSceneInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedBusinessLogic {
  func fetchFeed()

  func toggleFavoriteForImage(request: ScenesModels.Image.Update.Request)

  func fetchImage(request: ScenesModels.Image.Fetch.Request) -> ScenesModels.Image.Fetch.Response
}

protocol FeedDataStore {
  var feed: [Image]? { get }
}

class FeedInteractor: FeedBusinessLogic, FeedDataStore {
  var presenter: FeedPresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: imagesStore)
  var feed: [Image]?

  func fetchFeed() {
    imagesWorker.fetchFeedImages { [weak self] feed in
      guard let self = self else { return }

      self.feed = feed

      self.presenter?.presentFeed(response: .init(feed: feed))
    }
  }

  func toggleFavoriteForImage(request: ScenesModels.Image.Update.Request) {
    guard let feed = feed else { return }

    let image = feed.first { $0.id == request.id }

    guard let image = image else {
      return
    }

    image.isFavorite.toggle()

    presenter?.imageDidChange(response: .init(image: image))
  }

  func fetchImage(request: ScenesModels.Image.Fetch.Request) -> ScenesModels.Image.Fetch.Response {
    guard let feed = feed else {
      return .init(image: nil)
    }

    let image = feed.first { $0.id == request.id }

    return .init(image: image)
  }
}
