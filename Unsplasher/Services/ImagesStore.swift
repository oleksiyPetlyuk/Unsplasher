//
//  ImagesService.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation
import Moya

class ImagesStore: ImagesStoreProtocol {
  var allImages: [Image] = []

  let provider = MoyaProvider<Unsplash>(stubClosure: MoyaProvider.delayedStub(2))
  //  let provider = MoyaProvider<Unsplash>()

  func fetchImages(from topic: Topic, completion: @escaping (Result<[Image], Error>) -> Void) {
    if !allImages.isEmpty {
      completion(.success(allImages.filter { $0.topic == topic }))

      return
    }

    provider.request(.getTopicsPhotos(topic: topic)) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(let response):
        do {
          let images = try response.map([Image].self)

          images.forEach { $0.topic = topic }

          self.allImages.append(contentsOf: images)

          completion(.success(images))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
