//
//  SharedModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 16.11.2021.
//

import Foundation

// swiftlint:disable nesting
enum ScenesModels {
  struct DisplayedOwner {
    let name: String
    let avatarURL: URL
    let profileURL: URL
  }

  struct DisplayedImage: Identifiable {
    let id: Unsplasher.Image.ID
    let urls: Unsplasher.Image.ImageURL
    let owner: DisplayedOwner
    let isFavorite: Bool
    let topic: Topic
  }

  enum Image {
    struct ViewModel {
      let image: DisplayedImage
    }

    enum Fetch {
      struct Request {
        let id: Unsplasher.Image.ID
      }

      struct Response {
        let image: Unsplasher.Image?
      }
    }

    enum Update {
      struct Request {
        let id: Unsplasher.Image.ID
      }

      struct Response {
        let image: Unsplasher.Image
      }
    }
  }
}
