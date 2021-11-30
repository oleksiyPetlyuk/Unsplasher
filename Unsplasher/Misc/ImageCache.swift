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

class DefaultImageCache: ImageCache {
  let dataManager: DataIOManager

  init(dataManager: DataIOManager) {
    self.dataManager = dataManager
  }

  func get(_ key: String) -> Data? {
    guard let fileName = key.sha256 else { return nil }

    return dataManager.read(fromDocumentNamed: fileName)
  }

  func set(_ data: Data, for key: String) {
    guard let fileName = key.sha256 else { return }

    let queue = DispatchQueue(label: "images_cache")

    CallbackQueue.dispatch(queue).execute { [weak self] in
      try? self?.dataManager.write(data, toDocumentNamed: fileName)
    }
  }
}
