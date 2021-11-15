//
//  FeedScenePresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol FeedPresentationLogic {
  func presentFeed(response: Feed.FetchFeed.Response)

  func imageDidChange(response: Feed.UpdateImage.Response)
}

class FeedPresenter: FeedPresentationLogic {
  weak var viewController: FeedDisplayLogic?

  func presentFeed(response: Feed.FetchFeed.Response) {
    let feed = response.feed.compactMap { image in
      Feed.FetchFeed.ViewModel.DisplayedImage(
        id: image.id,
        urls: image.urls,
        owner: .init(name: image.owner.name, avatarURL: image.owner.avatarURL),
        isFavourite: image.isFavourite,
        topic: image.topic
      )
    }

    let viewModel = Feed.FetchFeed.ViewModel(feed: feed)
    viewController?.displayFeed(viewModel: viewModel)
  }

  func imageDidChange(response: Feed.UpdateImage.Response) {
    viewController?.imageDidChange(response: response)
  }
}
