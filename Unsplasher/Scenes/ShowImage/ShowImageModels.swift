//
//  ShowImageModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation

// swiftlint:disable nesting
enum ShowImage {
  enum GetImage {
    struct Request {}

    struct Response {
      let image: Image
    }

    struct ViewModel {
      struct DispalyedOwner {
        let name: String
        let avatarURL: URL
        let profileURL: URL
      }

      struct DisplayedImage {
        let urls: Image.ImageURL
        let owner: DispalyedOwner
        let isFavourite: Bool
      }

      var displayedImage: DisplayedImage
    }
  }

  enum OpenImageOwnerProfile {
    struct Request {}
  }

  enum UpdateImage {
    struct Request {}
  }
}
