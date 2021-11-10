//
//  ImagesService.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation
import Moya

class ImagesStore: ImagesStoreProtocol {
  let provider = MoyaProvider<Unsplash>(stubClosure: MoyaProvider.delayedStub(2))
  //  let provider = MoyaProvider<Unsplash>()

  func fetchImages(from topic: Topic, completion: @escaping (Result<[Image], Error>) -> Void) {
    provider.request(.getTopicsPhotos(topic: topic)) { result in
      switch result {
      case .success(let response):
        do {
          let images = try response.map([Image].self)

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
