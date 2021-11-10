//
//  Image.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 03.11.2021.
//

import Foundation

struct Image: Decodable {
  let id: String
  let urls: ImageURL
  let owner: Owner

  enum CodingKeys: String, CodingKey {
    case id, urls, owner = "user"
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

    // swiftlint:disable nesting
    enum CodingKeys: String, CodingKey {
      case name, profileImage = "profile_image"
    }

    enum ProfileImageKeys: CodingKey {
      case medium
    }
    // swiftlint:enable nesting

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decode(String.self, forKey: .name)

      let profileImageContainer = try container.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImage)
      self.avatarURL = try profileImageContainer.decode(URL.self, forKey: .medium)
    }
  }
}
