//
//  ShowImageRouter.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import Foundation

protocol ShowImageDataPassing {
  var dataStore: ShowImageDataStore? { get }
}

class ShowImageRouter: ShowImageDataPassing {
  weak var viewController: ShowImageViewController?
  var dataStore: ShowImageDataStore?
}
