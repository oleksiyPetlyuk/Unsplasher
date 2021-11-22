//
//  ImageCache.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 22.11.2021.
//

import Foundation

protocol ImageCache {
  func get(_ key: String) -> Data?

  func set(_ data: Data, for key: String)
}

struct DefaultImageCache: ImageCache {
  func get(_ key: String) -> Data? {
    guard let fileName = key.sha256 else { return nil }

    return FileIOController.read(fromDocumentNamed: fileName)
  }

  func set(_ data: Data, for key: String) {
    guard let fileName = key.sha256 else { return }

    let queue = DispatchQueue(label: "images_cache")

    CallbackQueue.dispatch(queue).execute {
      try? FileIOController.write(data, toDocumentNamed: fileName)
    }
  }
}
