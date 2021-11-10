//
//  FeedSceneInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedBusinessLogic {
  func fetchFeed(request: Feed.FetchImages.Request)
}

protocol FeedDataStore {
  var feed: [Topic: [Image]]? { get }
}

class FeedInteractor: FeedBusinessLogic, FeedDataStore {
  var presenter: FeedPresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: ImagesStore())
  var feed: [Topic: [Image]]?

  func fetchFeed(request: Feed.FetchImages.Request) {
    imagesWorker.fetchFeedImages { [weak self] feed in
      guard let self = self else { return }

      self.feed = feed

      let response = Feed.FetchImages.Response(feed: feed)
      self.presenter?.presentFeed(response: response)
    }
  }
}
