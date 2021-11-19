//
//  ImageCell.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 04.11.2021.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
  private(set) var imageView = UIImageView()
  private(set) var contentContainer = UIView()
  private(set) var ownerImage = UIImageView()

  func configure(with image: ScenesModels.DisplayedImage) {
    contentContainer.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(imageView)
    contentView.addSubview(contentContainer)

    imageView.kf.setImage(with: image.urls?.regularURL, options: [.transition(.fade(0.3))])
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 4
    imageView.clipsToBounds = true
    contentContainer.addSubview(imageView)

    ownerImage.translatesAutoresizingMaskIntoConstraints = false
    ownerImage.kf.setImage(with: image.owner?.avatar, options: [.transition(.fade(0.3))])
    ownerImage.layer.cornerRadius = 15
    ownerImage.layer.borderColor = UIColor.systemBackground.cgColor
    ownerImage.layer.borderWidth = 1
    ownerImage.clipsToBounds = true
    contentContainer.addSubview(ownerImage)

    if image.owner == nil {
      ownerImage.isHidden = true
    }

    NSLayoutConstraint.activate([
      contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),

      ownerImage.heightAnchor.constraint(equalToConstant: 30),
      ownerImage.widthAnchor.constraint(equalToConstant: 30),
      ownerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      ownerImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10)
    ])
  }
}
