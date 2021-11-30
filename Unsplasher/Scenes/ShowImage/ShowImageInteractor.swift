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
  func getImage(completion: ((Image?) -> Void)?)

  func observeImage()

  func openImageOwnerProfile()

  func toggleFavorite()

  func saveImageToPhotos()
}

extension ShowImageBusinessLogic {
  func getImage(completion: ((Image?) -> Void)? = nil) {
    return getImage(completion: nil)
  }
}

protocol ShowImageDataStore {
  var imageID: Image.ID? { get set }
}

class ShowImageInteractor: NSObject, ShowImageBusinessLogic, ShowImageDataStore {
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

  func getImage(completion: ((Image?) -> Void)? = nil) {
    guard let id = imageID else { return }

    imagesWorker.fetchImage(with: id) { [weak self] image in
      guard let self = self else { return }

      self.presenter?.presentImage(response: .init(image: image))

      completion?(image)
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

  func saveImageToPhotos() {
    presenter?.presentLoadingIndicator(response: .init(isActive: true))

    getImage { image in
      guard let image = image else { return }

      image.imageProvider.getUIImage { uiImage in
        if let uiImage = uiImage {
          let imageSaver = ImageSaver()

          imageSaver.writeToPhotoAlbum(
            image: uiImage,
            completionTarget: self,
            completionSelector: #selector(self.image(_:didFinishSavingWithError:contextInfo:))
          )
        }
      }
    }
  }

  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    presenter?.presentLoadingIndicator(response: .init(isActive: false))

    if let error = error {
      presenter?.presentAlert(response: .init(
        title: R.string.localizable.oops(),
        message: error.localizedDescription,
        actions: [action]
      ))
    } else {
      presenter?.presentAlert(response: .init(
        title: R.string.localizable.success(),
        message: R.string.localizable.imageWasSaved(),
        actions: [action]
      ))
    }
  }
}
