//
//  FeedSceneModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

enum Feed {
  enum FetchImages {}
}

extension Feed.FetchImages {
  struct Request {}

  struct Response {
    let feed: [Topic: [Image]]
  }

  struct ViewModel {
    let feed: [Topic: [DisplayedImage]]
  }
}

extension Feed.FetchImages.ViewModel {
  struct DisplayedOwner {
    let name: String
    let avatarURL: URL
  }
}

extension Feed.FetchImages.ViewModel {
  struct DisplayedImage: Hashable {
    private let uuid = UUID()

    let urls: Image.ImageURL
    let owner: DisplayedOwner

    static func == (lhs: DisplayedImage, rhs: DisplayedImage) -> Bool {
      return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }
  }
}
