//
//  ImageURLs.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 17.11.2021.
//

import Foundation
import RealmSwift

class ImageURLs: EmbeddedObject, Decodable {
  @Persisted var raw: String
  @Persisted var full: String
  @Persisted var regular: String

  var rawURL: URL? {
    URL(string: raw)
  }

  var fullURL: URL? {
    URL(string: full)
  }

  var regularURL: URL? {
    URL(string: regular)
  }
}
