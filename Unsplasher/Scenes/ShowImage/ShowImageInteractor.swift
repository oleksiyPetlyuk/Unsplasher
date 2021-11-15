//
//  ShowImageInteractor.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation
import UIKit

protocol ShowImageBusinessLogic {
  func getImage(request: ShowImage.GetImage.Request)

  func openImageOwnerProfile(request: ShowImage.OpenImageOwnerProfile.Request)

  func toggleFavourite(request: ShowImage.UpdateImage.Request)
}

protocol ShowImageDataStore {
  // swiftlint:disable:next implicitly_unwrapped_optional
  var image: Image! { get set }
}

class ShowImageInteractor: ShowImageBusinessLogic, ShowImageDataStore {
  var presenter: ShowImagePresentationLogic?

  // swiftlint:disable:next implicitly_unwrapped_optional
  var image: Image!

  func getImage(request: ShowImage.GetImage.Request) {
    presenter?.presentImage(response: .init(image: image))
  }

  func openImageOwnerProfile(request: ShowImage.OpenImageOwnerProfile.Request) {
    UIApplication.shared.open(image.owner.profileURL)
  }

  func toggleFavourite(request: ShowImage.UpdateImage.Request) {
    image.isFavourite.toggle()
    presenter?.presentImage(response: .init(image: image))
  }
}
