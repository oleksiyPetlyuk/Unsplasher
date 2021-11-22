//
//  CallbackQueue.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 22.11.2021.
//

import Foundation

enum CallbackQueue {
  case mainAsync
  case untouch
  case dispatch(DispatchQueue)
  
  func execute(_ block: @escaping () -> Void) {
    switch self {
    case .mainAsync:
      DispatchQueue.main.async { block() }
    case .untouch:
      block()
    case .dispatch(let queue):
      queue.async { block() }
    }
  }
}
