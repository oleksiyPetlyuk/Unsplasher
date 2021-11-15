//
//  FeedSceneModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

// swiftlint:disable nesting
enum Feed {
  enum FetchFeed {
    struct Request {}

    struct Response {
      let feed: [Image]
    }

    struct ViewModel {
      struct DisplayedOwner {
        let name: String
        let avatarURL: URL
      }

      struct DisplayedImage: Identifiable {
        let id: Image.ID
        let urls: Image.ImageURL
        let owner: DisplayedOwner
        let isFavourite: Bool
        let topic: Topic
      }

      let feed: [DisplayedImage]
    }
  }

  enum FetchImage {
    struct Request {
      let id: Image.ID
    }

    struct Response {
      let image: Image?
    }
  }

  enum UpdateImage {
    struct Request {
      let id: Image.ID
    }

    struct Response {
      let image: Image
    }
  }
}
