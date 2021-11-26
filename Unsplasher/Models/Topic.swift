//
//  Topic.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation
import RealmSwift

enum Topic: String, CaseIterable, CustomStringConvertible, PersistableEnum {
  case wallpapers = "wallpapers"
  case nature = "nature"
  case architecture = "architecture"
  case textures = "textures-patterns"
  case animals = "animals"

  var description: String {
    switch self {
    case .wallpapers:
      return R.string.localizable.wallpapers()
    case .nature:
      return R.string.localizable.nature()
    case .architecture:
      return R.string.localizable.architecture()
    case .textures:
      return R.string.localizable.texturesPatterns()
    case .animals:
      return R.string.localizable.animals()
    }
  }
}
