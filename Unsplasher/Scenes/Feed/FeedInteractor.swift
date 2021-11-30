//
//  FeedSceneInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation
import RealmSwift

protocol FeedBusinessLogic {
  func observeFeed()

  func toggleFavoriteForImage(request: ScenesModels.Image.Update.Request)

  func fetchImage(request: ScenesModels.Image.Fetch.Request, completion: @escaping (ScenesModels.Image.Fetch.Response) -> Void)

  func refreshFeed()
}

protocol FeedDataStore {
  var feed: [Image]? { get }
}

class FeedInteractor: FeedBusinessLogic, FeedDataStore {
  var presenter: FeedPresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: imagesStore)

  var feed: [Image]?

  var feedObservationToken: NotificationToken?

  lazy var feedObservationHandler: (RealmCollectionChange<Results<Image>>) -> Void = { [weak self] changes in
    guard let self = self else { return }

    self.presenter?.presentLoadingIndicator(response: .init(isActive: false))

    switch changes {
    case .initial(let results):
      self.presenter?.presentFeed(response: .init(feed: results.map(Image.init)))
    case let .update(results, _, insertions, modifications):
      if let modification = modifications.first {
        self.presenter?.presentFeed(response: .init(feed: [results[modification]]))
      }

      if !insertions.isEmpty {
        self.presenter?.presentFeed(response: .init(feed: results.map(Image.init)))
      }
    case .error(let error):
      print("Change error: \(error)")
    }
  }

  func observeFeed() {
    presenter?.presentLoadingIndicator(response: .init(isActive: true))

    imagesWorker.observeFeed(observeHandler: feedObservationHandler) { [weak self] token in
      guard let self = self else { return }

      self.feedObservationToken = token
    }
  }

  func toggleFavoriteForImage(request: ScenesModels.Image.Update.Request) {
    imagesWorker.toggleFavorite(for: request.id)
  }

  func fetchImage(request: ScenesModels.Image.Fetch.Request, completion: @escaping (ScenesModels.Image.Fetch.Response) -> Void) {
    imagesWorker.fetchImage(with: request.id) { image in
      completion(.init(image: image))
    }
  }

  func refreshFeed() {
    presenter?.presentLoadingIndicator(response: .init(isActive: true))

    imagesWorker.fetchFeed()
  }
}
