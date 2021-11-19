//
//  FeedScenePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedPresentationLogic {
  func presentFeed(response: Feed.Fetch.Response)
}

class FeedPresenter: FeedPresentationLogic {
  weak var viewController: FeedDisplayLogic?

  func presentFeed(response: Feed.Fetch.Response) {
    let feed: [ScenesModels.DisplayedImage] = response.feed.compactMap { image in
      var displayedOwner: ScenesModels.DisplayedImageOwner?

      if let owner = image.owner {
        displayedOwner = ScenesModels.DisplayedImageOwner(
          name: owner.name,
          avatar: owner.avatarURL,
          unsplashProfile: owner.unsplashProfileURL
        )
      }

      return ScenesModels.DisplayedImage(
        id: image.id,
        urls: image.urls,
        owner: displayedOwner,
        isFavorite: image.isFavorite,
        topic: image.topic
      )
    }

    viewController?.displayFeed(viewModel: .init(feed: feed))
  }
}
