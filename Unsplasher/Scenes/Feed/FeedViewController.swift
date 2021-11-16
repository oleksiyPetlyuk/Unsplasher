//
//  FeedSceneViewController.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import UIKit

protocol FeedDisplayLogic: AnyObject {
  func displayFeed(viewModel: Feed.Fetch.ViewModel)

  func imageDidChange(response: ScenesModels.Image.Update.Response)
}

class FeedViewController: UIViewController, FeedDisplayLogic {
  static let sectionHeaderElementKind = "section-header-element-kind"

  typealias DisplayedImage = ScenesModels.DisplayedImage

  var interactor: FeedBusinessLogic?
  var router: (NSObjectProtocol & FeedRoutingLogic & FeedDataPassing)?

  lazy private var doubleTapGesture: UITapGestureRecognizer = {
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
    doubleTapGesture.numberOfTapsRequired = 2
    doubleTapGesture.delaysTouchesBegan = true

    return doubleTapGesture
  }()

  // MARK: - Data Source

  lazy var dataSource: UICollectionViewDiffableDataSource<Topic, DisplayedImage.ID> = {
    let cellRegistration = UICollectionView.CellRegistration<FavoritableImageCell, DisplayedImage> { cell, _, image in
      cell.configure(with: image)
    }

    let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(
      elementKind: FeedViewController.sectionHeaderElementKind
    ) { supplementaryView, _, indexPath in
      supplementaryView.label.text = Topic.allCases[indexPath.section].description
    }

    let dataSource = UICollectionViewDiffableDataSource<Topic, DisplayedImage.ID>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, identifier -> UICollectionViewCell? in
      guard let self = self else { return nil }

      // `identifier` is an instance of `DisplayedImage.ID`. Use it to
      // retrieve the recipe from the backing data store.
      let response = self.interactor?.fetchImage(request: .init(id: identifier))

      guard let image = response?.image else { return nil }

      let displayedImage = DisplayedImage(
        id: image.id,
        urls: image.urls,
        owner: .init(name: image.owner.name, avatarURL: image.owner.avatarURL, profileURL: image.owner.profileURL),
        isFavorite: image.isFavorite,
        topic: image.topic
      )

      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: displayedImage)
    }

    dataSource.supplementaryViewProvider = { [weak self] _, _, indexPath in
      return self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
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

    navigationItem.title = "Feed"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)

    collectionView.addGestureRecognizer(doubleTapGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    fetchFeed()
  }

  // MARK: - Setup

  private func setup() {
    let viewController = self
    let interactor = FeedInteractor()
    let presenter = FeedPresenter()
    let router = FeedRouter()

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

  func fetchFeed() {
    interactor?.fetchFeed()
  }

  func displayFeed(viewModel: Feed.Fetch.ViewModel) {
    dataSource.applySnapshotUsingReloadData(snapshot(for: viewModel.feed))
  }

  func imageDidChange(response: ScenesModels.Image.Update.Response) {
    let image = response.image

    // Confirm that the data source contains the image.
    guard dataSource.indexPath(for: image.id) != nil else { return }

    var snapshot = dataSource.snapshot()
    snapshot.reconfigureItems([image.id])
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  // MARK: - Toggle favorite

  @objc func didDoubleTapCollectionView() {
    let pointInCollectionView = doubleTapGesture.location(in: collectionView)

    if
      let selectedIndexPath = collectionView.indexPathForItem(at: pointInCollectionView),
      let imageId = dataSource.itemIdentifier(for: selectedIndexPath) {
      interactor?.toggleFavoriteForImage(request: .init(id: imageId))
    }
  }
}

extension FeedViewController {
  func snapshot(for feed: [DisplayedImage]) -> NSDiffableDataSourceSnapshot<Topic, DisplayedImage.ID> {
    var snapshot = dataSource.snapshot()

    for topic in Topic.allCases {
      if snapshot.indexOfSection(topic) == nil {
        snapshot.appendSections([topic])
      }
    }

    feed.forEach { image in
      if snapshot.indexOfItem(image.id) == nil {
        snapshot.appendItems([image.id], toSection: image.topic)
      } else {
        snapshot.reconfigureItems([image.id])
      }
    }

    return snapshot
  }

  func generateLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
      let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500

      let sectionLayoutKind = Topic.allCases[sectionIndex]

      switch sectionLayoutKind {
      case .wallpapers, .animals:
        return layoutProvider.fullWidthLayout(
          isWide: isWideView,
          supplementaryElementKind: Self.sectionHeaderElementKind
        )
      case .nature, .textures:
        return layoutProvider.thirdWidthLayout(supplementaryElementKind: Self.sectionHeaderElementKind)
      case .architecture:
        return layoutProvider.gridLayout(isWide: isWideView, supplementaryElementKind: Self.sectionHeaderElementKind)
      }
    }

    return layout
  }
}

extension FeedViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ShowImage", sender: nil)
  }
}
