//
//  ImagesService.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import Foundation
import Moya
import RealmSwift

let imagesStore = ImagesStore()

class ImagesStore: ImagesStoreProtocol {
  //  let unsplashProvider = MoyaProvider<Unsplash>(stubClosure: MoyaProvider.delayedStub(2))
  let unsplashProvider = MoyaProvider<Unsplash>()

  var realm: Realm

  init() {
    do {
      realm = try Realm()
    } catch {
      fatalError("Runtime Error: Cannot create Realm")
    }
  }

  func observeImages(observeHandler: @escaping (RealmCollectionChange<Results<Image>>) -> Void, completion: @escaping (NotificationToken?) -> Void) {
    let storedImages = realm.objects(Image.self).sorted(byKeyPath: "modifiedAt")

    if !storedImages.isEmpty {
      completion(storedImages.observe(observeHandler))

      return
    }

    fetchFeed {
      completion(storedImages.observe(observeHandler))
    }
  }

  func observeImage(with id: Image.ID, observeHandler: @escaping (ObjectChange<Image>) -> Void) -> NotificationToken? {
    let image = realm.object(ofType: Image.self, forPrimaryKey: id)

    guard let image = image else { return nil }

    return image.observe(observeHandler)
  }

  func fetchFavorites(completion: @escaping (Result<[Image], Error>) -> Void) {
    let favorites = realm.objects(Image.self).where { $0.isFavorite == true }.sorted(byKeyPath: "modifiedAt")

    completion(.success(favorites.map(Image.init)))
  }

  func fetchImage(with id: Image.ID, completion: @escaping (Result<Image?, Error>) -> Void) {
    let image = realm.object(ofType: Image.self, forPrimaryKey: id)

    completion(.success(image))
  }

  func updateImage(with id: Image.ID, set field: String, equalTo newValue: Any?) {
    let image = realm.object(ofType: Image.self, forPrimaryKey: id)

    guard let image = image else { return }

    try? realm.write {
      image.setValue(newValue, forKey: field)
    }
  }

  func fetchFeed(completion: @escaping () -> Void) {
    let group = DispatchGroup()

    for topic in Topic.allCases {
      group.enter()

      unsplashProvider.request(.getTopicsPhotos(topic: topic)) { [weak self] result in
        defer {
          group.leave()
        }

        guard let self = self else { return }

        switch result {
        case .success(let response):
          do {
            let images = try response.map([Image].self)

            images.forEach { $0.topic = topic }

            try self.realm.write {
              self.realm.add(images, update: .modified)
            }
          } catch {
            print(error)
          }
        case .failure(let error):
          print(error)
        }
      }
    }

    group.notify(queue: .main) {
      completion()
    }
  }
}
