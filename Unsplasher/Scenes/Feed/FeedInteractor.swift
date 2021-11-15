//
//  FeedSceneInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedBusinessLogic {
  func fetchFeed(request: Feed.FetchFeed.Request)

  func toggleFavouriteForImage(request: Feed.UpdateImage.Request)

  func fetchImage(request: Feed.FetchImage.Request) -> Feed.FetchImage.Response
}

protocol FeedDataStore {
  var feed: [Image]? { get }
}

class FeedInteractor: FeedBusinessLogic, FeedDataStore {
  var presenter: FeedPresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: ImagesStore())
  var feed: [Image]?

  func fetchFeed(request: Feed.FetchFeed.Request) {
    imagesWorker.fetchFeedImages { [weak self] feed in
      guard let self = self else { return }

      self.feed = feed

      self.presenter?.presentFeed(response: .init(feed: feed))
    }
  }

  func toggleFavouriteForImage(request: Feed.UpdateImage.Request) {
    guard let feed = feed else { return }

    let image = feed.first { $0.id == request.id }

    guard let image = image else {
      return
    }

    image.isFavourite.toggle()

    presenter?.imageDidChange(response: .init(image: image))
  }

  func fetchImage(request: Feed.FetchImage.Request) -> Feed.FetchImage.Response {
    guard let feed = feed else {
      return .init(image: nil)
    }

    let image = feed.first { $0.id == request.id }

    return .init(image: image)
  }
}
