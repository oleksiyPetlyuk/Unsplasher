//
//  ImageOwner.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 17.11.2021.
//

import Foundation
import RealmSwift

class ImageOwner: EmbeddedObject, Decodable {
  @Persisted var name: String
  @Persisted var avatar: String
  @Persisted var unsplashProfile: String

  var avatarURL: URL? {
    URL(string: avatar)
  }

  var unsplashProfileURL: URL? {
    URL(string: unsplashProfile)
  }

  enum CodingKeys: String, CodingKey {
    case name, links, profileImage = "profile_image"
  }

  enum ProfileImageKeys: CodingKey {
    case medium
  }

  enum LinksKeys: CodingKey {
    case html
  }

  required override init() {
    super.init()
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)

    let profileImageContainer = try container.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImage)
    self.avatar = try profileImageContainer.decode(String.self, forKey: .medium)

    let linksContainer = try container.nestedContainer(keyedBy: LinksKeys.self, forKey: .links)
    self.unsplashProfile = try linksContainer.decode(String.self, forKey: .html)
  }
}
