//
//  Image.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 03.11.2021.
//

import Foundation

class Image: Identifiable, Decodable {
  let id = UUID()
  let urls: ImageURL
  let owner: Owner
  var isFavourite = false
  // swiftlint:disable:next implicitly_unwrapped_optional
  var topic: Topic!

  enum CodingKeys: String, CodingKey {
    case urls, owner = "user"
  }
}

extension Image {
  struct ImageURL: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
  }
}

extension Image {
  struct Owner: Decodable {
    let name: String
    let avatarURL: URL
    let profileURL: URL

    // swiftlint:disable nesting
    enum CodingKeys: String, CodingKey {
      case name, links, profileImage = "profile_image"
    }

    enum ProfileImageKeys: CodingKey {
      case medium
    }

    enum LinksKeys: CodingKey {
      case html
    }
    // swiftlint:enable nesting

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decode(String.self, forKey: .name)

      let profileImageContainer = try container.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImage)
      self.avatarURL = try profileImageContainer.decode(URL.self, forKey: .medium)

      let linksContainer = try container.nestedContainer(keyedBy: LinksKeys.self, forKey: .links)
      self.profileURL = try linksContainer.decode(URL.self, forKey: .html)
    }
  }
}
