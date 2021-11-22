//
//  FavoritableImageCell.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 16.11.2021.
//

import UIKit

class FavoritableImageCell: ImageCell {
  private let isFavoriteImage = UIImageView()

  override func configure(with image: ScenesModels.DisplayedImage) {
    super.configure(with: image)

    isFavoriteImage.image = UIImage(systemName: "heart.fill")
    isFavoriteImage.tintColor = .systemBackground
    isFavoriteImage.isHidden = !image.isFavorite

    isFavoriteImage.translatesAutoresizingMaskIntoConstraints = false
    contentContainer.addSubview(isFavoriteImage)

    NSLayoutConstraint.activate([
      isFavoriteImage.heightAnchor.constraint(equalToConstant: 30),
      isFavoriteImage.widthAnchor.constraint(equalToConstant: 30),
      isFavoriteImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      isFavoriteImage.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10)
    ])
  }
}
