//
//  FeedSceneModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

// swiftlint:disable nesting
enum Feed {
  enum Fetch {
    struct Response {
      let feed: [Image]
    }

    struct ViewModel {
      let feed: [ScenesModels.DisplayedImage]
    }
  }
}
