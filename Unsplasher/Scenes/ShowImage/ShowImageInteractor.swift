//
//  ShowImageInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol ShowImageBusinessLogic {
  func getImage()

  func observeImage()

  func openImageOwnerProfile()

  func toggleFavorite()
}

protocol ShowImageDataStore {
  var imageID: Image.ID? { get set }
}

class ShowImageInteractor: ShowImageBusinessLogic, ShowImageDataStore {
  var imageID: Image.ID?

  var presenter: ShowImagePresentationLogic?

  var imagesWorker = ImagesWorker(imagesStore: imagesStore)

  var observationToken: NotificationToken?

  lazy var observationHandler: (ObjectChange<Image>) -> Void = { [weak self] change in
    guard let self = self else { return }

    switch change {
    case .change(let image, _):
      self.presenter?.presentImage(response: .init(image: image))
    case .deleted:
      print("The object was deleted.")
    case .error(let error):
      print(error)
    }
  }

  func observeImage() {
    guard let id = imageID else { return }

    let token = imagesWorker.observeImage(with: id, observeHandler: observationHandler)

    guard let token = token else { return }

    self.observationToken = token
  }

  func getImage() {
    guard let id = imageID else { return }

    imagesWorker.fetchImage(with: id) { [weak self] image in
      guard let self = self else { return }

      self.presenter?.presentImage(response: .init(image: image))
    }
  }

  func openImageOwnerProfile() {
    guard let id = imageID else { return }


    imagesWorker.fetchImage(with: id) { image in
      guard let image = image, let url = image.owner?.unsplashProfileURL else { return }

      UIApplication.shared.open(url)
    }
  }

  func toggleFavorite() {
    guard let id = imageID else { return }

    imagesWorker.toggleFavorite(for: id)
  }
}
