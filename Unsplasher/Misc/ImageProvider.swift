//
//  ImageProvider.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 19.11.2021.
//

import UIKit

class ImageProvider<Base> {
  let base: Base
  var task: URLSessionDataTask?
  let responseQueue: DispatchQueue
  let session: URLSession
  let cache: ImageCache

  init(_ base: Base, responseQueue: DispatchQueue = .main, session: URLSession = .shared, cache: ImageCache? = nil) {
    self.base = base
    self.responseQueue = responseQueue
    self.session = session

    if let cache = cache {
      self.cache = cache
    } else {
      self.cache = DefaultImageCache(dataManager: FileIOController())
    }
  }
}

extension ImageProvider {
  @discardableResult
  private func download(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
    let cachedData = cache.get(url.absoluteString)

    if let cachedData = cachedData, let cachedImage = UIImage(data: cachedData) {
      CallbackQueue.mainAsync.execute {
        completion(.success(cachedImage))
      }

      return nil
    }

    let dataTask = session.dataTask(with: url) { data, _, error in
      if let error = error {
        CallbackQueue.mainAsync.execute {
          completion(.failure(error))
        }
      }

      if let data = data, let image = UIImage(data: data) {
        self.cache.set(data, for: url.absoluteString)

        CallbackQueue.mainAsync.execute {
          completion(.success(image))
        }
      } else {
        CallbackQueue.mainAsync.execute {
          completion(.failure(ImageProviderError.decodingError))
        }
      }
    }

    dataTask.resume()

    return dataTask
  }
}

extension ImageProvider where Base: UIImageView {
  func setImage(from url: URL?, placeholder: UIImage? = nil) {
    guard let url = url else { return }

    task?.cancel()

    base.image = placeholder

    task = download(from: url) { result in
      self.task = nil

      switch result {
      case .success(let image):
        self.base.image = image
      case .failure(let error):
        print("Image client error: \(error)")
      }
    }
  }
}

extension ImageProvider where Base: Image {
  func getUIImage(completion: @escaping (UIImage?) -> Void) {
    guard let urls = base.urls, let url = urls.rawURL else {
      completion(nil)

      return
    }

    download(from: url) { result in
      switch result {
      case .failure(let error):
        print(error)
        completion(nil)
      case .success(let image):
        completion(image)
      }
    }
  }
}

extension ImageProvider {
  enum ImageProviderError: Error {
    case decodingError
  }
}

protocol ImageProviderCompatible: AnyObject {}

extension ImageProviderCompatible {
  var imageProvider: ImageProvider<Self> {
    return ImageProvider(self)
  }
}

extension UIImageView: ImageProviderCompatible {}

extension Image: ImageProviderCompatible {}
