//
//  Image.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 03.11.2021.
//

import Foundation
import RealmSwift

class Image: Object, Identifiable, Decodable {
  @Persisted(primaryKey: true) var id: String
  @Persisted var urls: ImageURLs?
  @Persisted var owner: ImageOwner?
  @Persisted var isFavorite = false
  @Persisted var topic: Topic?
  @Persisted var modifiedAt = Date()

  enum CodingKeys: String, CodingKey {
    case id, urls, owner = "user"
  }
}
