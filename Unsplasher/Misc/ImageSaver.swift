//
//  ImageSaver.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 25.11.2021.
//

import UIKit

class ImageSaver: NSObject {
  func writeToPhotoAlbum(image: UIImage, completionTarget: Any? = nil, completionSelector: Selector? = nil) {
    if let completionTarget = completionTarget, let completionSelector = completionSelector {
      UIImageWriteToSavedPhotosAlbum(image, completionTarget, completionSelector, nil)

      return
    }

    UIImageWriteToSavedPhotosAlbum(image, self, #selector(completionHandler), nil)
  }

  @objc func completionHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    print("Save finished!")
  }
}
