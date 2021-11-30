//
//  LoadingIndicator.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 30.11.2021.
//

import UIKit

class LoadingIndicator: UIView {
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private let overlay = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupOverlay()
    setupActivityIndicator()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setupOverlay() {
    addSubview(overlay)

    overlay.translatesAutoresizingMaskIntoConstraints = false
    overlay.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    overlay.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    overlay.topAnchor.constraint(equalTo: topAnchor).isActive = true
    overlay.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    overlay.backgroundColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)
  }

  private func setupActivityIndicator() {
    addSubview(activityIndicator)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    activityIndicator.color = .white
  }
}

extension LoadingIndicator {
  func startAnimating() {
    activityIndicator.startAnimating()
    isHidden = false
  }

  func stopAnimating() {
    activityIndicator.stopAnimating()
    isHidden = true
  }
}
