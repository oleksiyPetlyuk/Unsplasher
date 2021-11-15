//
//  ImagesWorker.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation

protocol ImagesStoreProtocol {
  func fetchImages(from topic: Topic, completion: @escaping (Result<[Image], Error>) -> Void)
}

class ImagesWorker {
  var imagesStore: ImagesStoreProtocol

  init(imagesStore: ImagesStoreProtocol) {
    self.imagesStore = imagesStore
  }

  func fetchFeedImages(completion: @escaping ([Image]) -> Void) {
    var feed: [Image] = []
    let group = DispatchGroup()

    for topic in Topic.allCases {
      group.enter()

      imagesStore.fetchImages(from: topic) { result in
        switch result {
        case .failure(let error):
          print(error)
        case .success(let images):
          feed.append(contentsOf: images)
        }

        group.leave()
      }
    }

    group.notify(queue: .main) {
      completion(feed)
    }
  }
}
