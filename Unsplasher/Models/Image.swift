//
//  Image.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 03.11.2021.
//

import Foundation

struct Image: Decodable {
  struct ImageURL: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
  }

  let id: String
  let urls: ImageURL
}
