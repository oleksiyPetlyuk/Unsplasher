//
//  FeedSceneRouter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import UIKit

protocol FeedRoutingLogic {
  func routeToShowImage(segue: UIStoryboardSegue?)
}

protocol FeedDataPassing {
  var dataStore: FeedDataStore? { get }
}

class FeedRouter: FeedRoutingLogic, FeedDataPassing {
  weak var viewController: FeedViewController?
  var dataStore: FeedDataStore?

  func routeToShowImage(segue: UIStoryboardSegue?) {}
}
