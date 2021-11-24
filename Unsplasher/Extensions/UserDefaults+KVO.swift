//
//  UserDefaults+KVO.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 24.11.2021.
//

import Foundation

extension UserDefaults {
  @objc dynamic var applicationTheme: String? {
    return string(forKey: "applicationTheme")
  }
}
