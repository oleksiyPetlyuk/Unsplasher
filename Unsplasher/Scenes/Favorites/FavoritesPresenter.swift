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
    let favorites: [ScenesModels.DisplayedImage] = response.images.compactMap { image in
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

    viewController?.displayFavorites(viewModel: .init(images: favorites))
  }
}
