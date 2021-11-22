//
//  ShowImageViewController.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 11.11.2021.
//

import UIKit

protocol ShowImageDisplayLogic: AnyObject {
  func displayImage(viewModel: ScenesModels.Image.ViewModel)
}

class ShowImageViewController: UIViewController, ShowImageDisplayLogic {
  var interactor: ShowImageBusinessLogic?
  var router: ShowImageDataPassing?

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var ownerLabel: UILabel!
  @IBOutlet weak var ownerImage: UIImageView!

  // MARK: - Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setup()
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    let ownerLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOwnerProfile))
    let ownerImageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOwnerProfile))
    ownerLabel.addGestureRecognizer(ownerLabelTapRecognizer)
    ownerImage.addGestureRecognizer(ownerImageTapRecognizer)

    getImage()
  }

  // MARK: - Setup

  private func setup() {
    let viewController = self
    let interactor = ShowImageInteractor()
    let presenter = ShowImagePresenter()
    let router = ShowImageRouter()

    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: - Get image

  func getImage() {
    interactor?.getImage()
    interactor?.observeImage()
  }

  func displayImage(viewModel: ScenesModels.Image.ViewModel) {
    let image = viewModel.image

    let favoriteImageName = image.isFavorite ? "heart.fill" : "heart"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: .init(systemName: favoriteImageName),
      style: .plain,
      target: self,
      action: #selector(toggleFavorite)
    )

    imageView.imageProvider.setImage(from: image.urls?.regularURL)

    let plainAttributedString = NSMutableAttributedString(string: "From ")
    let attributedLinkString = NSMutableAttributedString(string: image.owner?.name ?? "Unsplash", attributes: [
      .attachment: image.owner?.unsplashProfile ?? "https://unsplash.com",
      .foregroundColor: UIColor.placeholderText,
      .underlineStyle: NSUnderlineStyle.single.rawValue,
      .underlineColor: UIColor.placeholderText
    ])
    let fullAttributedString = NSMutableAttributedString()

    fullAttributedString.append(plainAttributedString)
    fullAttributedString.append(attributedLinkString)

    ownerLabel.attributedText = fullAttributedString

    ownerImage.imageProvider.setImage(from: image.owner?.avatar)
    ownerImage.layer.cornerRadius = 25
    ownerImage.layer.borderColor = UIColor.systemBackground.cgColor
    ownerImage.layer.borderWidth = 1
  }

  @objc func openOwnerProfile(_ sender: UITapGestureRecognizer) {
    interactor?.openImageOwnerProfile()
  }

  @objc func toggleFavorite() {
    interactor?.toggleFavorite()
  }
}
