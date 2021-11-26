//
//  FeedSceneRouter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import UIKit

@objc protocol FeedRoutingLogic {
  func routeToShowImage(segue: UIStoryboardSegue?)
}

protocol FeedDataPassing {
  var dataStore: FeedDataStore? { get }
}

class FeedRouter: NSObject, FeedRoutingLogic, FeedDataPassing {
  weak var viewController: FeedViewController?
  var dataStore: FeedDataStore?

  // MARK: - Routing

  func routeToShowImage(segue: UIStoryboardSegue?) {
    if let segue = segue {
      guard
        let dataStore = dataStore,
        let typedInfo = R.segue.feedViewController.showImage(segue: segue),
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

  func navigateToShowImage(source: FeedViewController, destination: ShowImageViewController) {
    source.show(destination, sender: nil)
  }

  // MARK: - Passing data

  func passDataToShowImage(source: FeedDataStore, destination: inout ShowImageDataStore) {
    guard
      let selectedItemIndexPath = viewController?.collectionView.indexPathsForSelectedItems?.first,
      let imageID = viewController?.dataSource.itemIdentifier(for: selectedItemIndexPath) else {
        return
      }

    destination.imageID = imageID
  }
}
