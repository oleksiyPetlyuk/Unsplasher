//
//  FeedScenePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedPresentationLogic {
  func presentFeed(response: Feed.Fetch.Response)

  func imageDidChange(response: ScenesModels.Image.Update.Response)
}

class FeedPresenter: FeedPresentationLogic {
  weak var viewController: FeedDisplayLogic?

  func presentFeed(response: Feed.Fetch.Response) {
    let feed = response.feed.compactMap { image in
      ScenesModels.DisplayedImage(
        id: image.id,
        urls: image.urls,
        owner: .init(name: image.owner.name, avatarURL: image.owner.avatarURL, profileURL: image.owner.profileURL),
        isFavorite: image.isFavorite,
        topic: image.topic
      )
    }

    viewController?.displayFeed(viewModel: .init(feed: feed))
  }

  func imageDidChange(response: ScenesModels.Image.Update.Response) {
    viewController?.imageDidChange(response: response)
  }
}
