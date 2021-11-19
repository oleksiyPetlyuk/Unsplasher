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
      return "Wallpapers"
    case .nature:
      return "Nature"
    case .architecture:
      return "Architecture"
    case .textures:
      return "Textures & Patterns"
    case .animals:
      return "Animals"
    }
  }
}
