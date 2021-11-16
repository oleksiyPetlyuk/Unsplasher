//
//  FavoritesPresenter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import Foundation

protocol FavoritesPresentationLogic {
  func presentFavorites(response: Favorites.Fetch.Response)
}

class FavoritesPresenter: FavoritesPresentationLogic {
  weak var viewController: FavoritesDisplayLogic?

  func presentFavorites(response: Favorites.Fetch.Response) {
    let favorites = response.images.compactMap { image in
      ScenesModels.DisplayedImage(
        id: image.id,
        urls: image.urls,
        owner: .init(name: image.owner.name, avatarURL: image.owner.avatarURL, profileURL: image.owner.profileURL),
        isFavorite: image.isFavorite,
        topic: image.topic
      )
    }

    viewController?.displayFavorites(viewModel: .init(images: favorites))
  }
}
