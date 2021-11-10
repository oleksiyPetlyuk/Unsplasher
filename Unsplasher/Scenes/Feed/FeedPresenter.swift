//
//  FeedScenePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedPresentationLogic {
  func presentFeed(response: Feed.FetchImages.Response)
}

class FeedPresenter: FeedPresentationLogic {
  weak var viewController: FeedDisplayLogic?

  func presentFeed(response: Feed.FetchImages.Response) {
    let feed = response.feed.mapValues { images in
      images.compactMap { image in
        Feed.FetchImages.ViewModel.DisplayedImage(
          urls: image.urls,
          owner: Feed.FetchImages.ViewModel.DisplayedOwner(name: image.owner.name, avatarURL: image.owner.avatarURL)
        )
      }
    }

    let viewModel = Feed.FetchImages.ViewModel(feed: feed)
    viewController?.displayFeed(viewModel: viewModel)
  }
}
