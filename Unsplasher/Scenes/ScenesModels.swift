//
//  SharedModels.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 16.11.2021.
//

import Foundation
import UIKit

// swiftlint:disable nesting
enum ScenesModels {
  struct DisplayedImageOwner {
    let name: String
    let avatar: URL?
    let unsplashProfile: URL?
  }

  struct DisplayedImage: Identifiable {
    let id: Unsplasher.Image.ID
    let urls: ImageURLs?
    let owner: DisplayedImageOwner?
    let isFavorite: Bool
    let topic: Topic?
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

  enum Alert {
    struct DataModel {
      let title: String?
      let message: String?
      let style: UIAlertController.Style = .alert
      let actions: [UIAlertAction]?
    }

    struct ViewModel {
      let alert: DataModel
    }

    struct Response {
      let title: String?
      let message: String?
      let actions: [UIAlertAction]?
    }
  }
}
