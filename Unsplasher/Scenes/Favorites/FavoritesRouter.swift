//
//  FavoritesRouter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import UIKit

@objc protocol FavoritesRoutingLogic {
  func routeToShowImage(segue: UIStoryboardSegue?)
}

protocol FavoritesDataPassing {
  var dataStore: FavoritesDataStore? { get }
}

class FavoritesRouter: NSObject, FavoritesRoutingLogic, FavoritesDataPassing {
  weak var viewController: FavoritesViewController?
  var dataStore: FavoritesDataStore?

  // MARK: - Routing

  func routeToShowImage(segue: UIStoryboardSegue?) {
    if let segue = segue {
      guard
        let dataStore = dataStore,
        let typedInfo = R.segue.favoritesViewController.showImage(segue: segue),
        var destinationDataStore = typedInfo.destination.router?.dataStore else {
          return
        }

      passDataToShowImage(source: dataStore, destination: &destinationDataStore)
    } else {
      guard
        let viewController = viewController,
        let dataStore = dataStore,
        let destinationViewController = R.storyboard.main.showImageViewController(),
        var destinationDataStore = destinationViewController.router?.dataStore else {
          return
        }

      passDataToShowImage(source: dataStore, destination: &destinationDataStore)
      navigateToShowImage(source: viewController, destination: destinationViewController)
    }
  }

  // MARK: - Navigation

  func navigateToShowImage(source: FavoritesViewController, destination: ShowImageViewController) {
    source.show(destination, sender: nil)
  }

  // MARK: - Passing data

  func passDataToShowImage(source: FavoritesDataStore, destination: inout ShowImageDataStore) {
    guard
      let selectedItemIndexPath = viewController?.collectionView.indexPathsForSelectedItems?.first,
      let imageID = viewController?.dataSource.itemIdentifier(for: selectedItemIndexPath) else {
        return
      }

    destination.imageID = imageID
  }
}
