//
//  FavoritesViewController.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import UIKit

protocol FavoritesDisplayLogic: AnyObject {
  func displayFavorites(viewModel: Favorites.Fetch.ViewModel)
}

class FavoritesViewController: UIViewController, FavoritesDisplayLogic {
  enum Section {
    case main
  }

  typealias DisplayedImage = ScenesModels.DisplayedImage

  var interactor: FavoritesBusinessLogic?
  var router: (NSObjectProtocol & FavoritesRoutingLogic & FavoritesDataPassing)?

  // MARK: - Data Source

  lazy var dataSource: UICollectionViewDiffableDataSource<Section, DisplayedImage.ID> = {
    let cellRegistration = UICollectionView.CellRegistration<ImageCell, DisplayedImage> { cell, _, image in
      cell.configure(with: image)
    }

    let dataSource = UICollectionViewDiffableDataSource<Section, DisplayedImage.ID>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, identifier -> UICollectionViewCell? in
      guard let self = self else { return nil }

      let semaphore = DispatchSemaphore(value: 0)
      var image: Image?

      // `identifier` is an instance of `DisplayedImage.ID`. Use it to
      // retrieve the recipe from the backing data store.
      self.interactor?.fetchImage(request: .init(id: identifier)) { response in
        image = response.image

        semaphore.signal()
      }

      semaphore.wait()

      guard let image = image else { return nil }

      var displayedOwner: ScenesModels.DisplayedImageOwner?

      if let owner = image.owner {
        let displayedOwner = ScenesModels.DisplayedImageOwner(
          name: owner.name,
          avatar: owner.avatarURL,
          unsplashProfile: owner.unsplashProfileURL
        )
      }

      let displayedImage = DisplayedImage(
        id: image.id,
        urls: image.urls,
        owner: displayedOwner,
        isFavorite: image.isFavorite,
        topic: image.topic
      )

      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: displayedImage)
    }

    return dataSource
  }()

  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self

    return collectionView
  }()

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

    navigationItem.title = "Favorites"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    fetchFavorites()
  }

  // MARK: - Setup

  private func setup() {
    let viewController = self
    let interactor = FavoritesInteractor()
    let presenter = FavoritesPresenter()
    let router = FavoritesRouter()

    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: - Routing

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")

      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }

  // MARK: - Fetch images

  func fetchFavorites() {
    interactor?.fetchFavorites()
  }

  func displayFavorites(viewModel: Favorites.Fetch.ViewModel) {
    dataSource.applySnapshotUsingReloadData(snapshot(for: viewModel.images))
  }
}

extension FavoritesViewController {
  func snapshot(for images: [DisplayedImage]) -> NSDiffableDataSourceSnapshot<Section, DisplayedImage.ID> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, DisplayedImage.ID>()

    snapshot.appendSections([.main])
    snapshot.appendItems(images.map { $0.id }, toSection: .main)

    return snapshot
  }

  func generateLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
      let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500

      return layoutProvider.gridLayout(isWide: isWideView)
    }

    return layout
  }
}

extension FavoritesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ShowImage", sender: nil)
  }
}
