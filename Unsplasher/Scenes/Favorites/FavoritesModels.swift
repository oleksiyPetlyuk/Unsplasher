//
//  FavoritesModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import Foundation

// swiftlint:disable nesting
enum Favorites {
  enum Fetch {
    struct Response {
      let images: [Image]
    }

    struct ViewModel {
      let images: [ScenesModels.DisplayedImage]
    }
  }

  enum Delete {
    
  }
}
