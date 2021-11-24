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
      return NSLocalizedString("wallpapers", comment: "wallpapers")
    case .nature:
      return NSLocalizedString("nature", comment: "nature")
    case .architecture:
      return NSLocalizedString("architecture", comment: "architecture")
    case .textures:
      return NSLocalizedString("textures-patterns", comment: "textures-patterns")
    case .animals:
      return NSLocalizedString("animals", comment: "animals")
    }
  }
}
