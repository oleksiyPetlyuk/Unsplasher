//
//  FeedSceneViewController.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 09.11.2021.
//

import UIKit

protocol FeedDisplayLogic: AnyObject {
  func displayFeed(viewModel: Feed.FetchImages.ViewModel)
}

class FeedViewController: UIViewController, UICollectionViewDelegate, FeedDisplayLogic {
  static let sectionHeaderElementKind = "section-header-element-kind"

  typealias DisplayedImage = Feed.FetchImages.ViewModel.DisplayedImage

  var interactor: FeedBusinessLogic?
  var router: (FeedRoutingLogic & FeedDataPassing)?

  // MARK: - Data Source

  lazy var dataSource: UICollectionViewDiffableDataSource<Topic, DisplayedImage> = {
    let dataSource = UICollectionViewDiffableDataSource<Topic, DisplayedImage>(collectionView: collectionView) {
      // swiftlint:disable:next closure_parameter_position
      (collectionView: UICollectionView, indexPath: IndexPath, image: DisplayedImage) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ImageCell.reuseIdentifer,
        for: indexPath
      ) as? ImageCell else {
        fatalError("Could not create new cell")
      }

      cell.configure(with: image)

      return cell
    }

    // swiftlint:disable:next line_length
    dataSource.supplementaryViewProvider = {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
      guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: HeaderView.reuseIdentifier,
        for: indexPath
      ) as? HeaderView else {
        fatalError("Cannot create header view")
      }

      supplementaryView.label.text = Topic.allCases[indexPath.section].description

      return supplementaryView
    }

    return dataSource
  }()

  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self

    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifer)

    collectionView.register(
      HeaderView.self,
      forSupplementaryViewOfKind: FeedViewController.sectionHeaderElementKind,
      withReuseIdentifier: HeaderView.reuseIdentifier
    )

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

  // MARK: - Fetch images

  func fetchFeed() {
    let request = Feed.FetchImages.Request()
    interactor?.fetchFeed(request: request)
  }

  func displayFeed(viewModel: Feed.FetchImages.ViewModel) {
    dataSource.apply(snapshot(for: viewModel.feed), animatingDifferences: true)
  }
}

extension FeedViewController {
  func snapshot(for feed: [Topic: [DisplayedImage]]) -> NSDiffableDataSourceSnapshot<Topic, DisplayedImage> {
    var snapshot = NSDiffableDataSourceSnapshot<Topic, DisplayedImage>()

    snapshot.appendSections(Topic.allCases)

    feed.forEach { topic, images in
      snapshot.appendItems(images, toSection: topic)
    }

    return snapshot
  }

  func generateLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout {
      // swiftlint:disable:next closure_parameter_position
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500

      let sectionLayoutKind = Topic.allCases[sectionIndex]

      switch sectionLayoutKind {
      case .wallpapers, .animals: return self.generateFullWidthLayout(isWide: isWideView)
      case .nature, .textures: return self.generateThirdWidthLayout()
      case .architecture: return self.generateGridLayout(isWide: isWideView)
      }
    }

    return layout
  }

  func generateFullWidthLayout(isWide: Bool) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalWidth(2 / 3)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // Show one item plus peek on narrow screens, two items plus peek on wider screens
    let groupFractionalWidth = isWide ? 0.475 : 0.95
    let groupFractionalHeight: Float = isWide ? 1 / 3 : 2 / 3
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
      heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight))
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: FeedViewController.sectionHeaderElementKind,
      alignment: .top
    )

    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [sectionHeader]
    section.orthogonalScrollingBehavior = .groupPaging

    return section
  }

  func generateThirdWidthLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalWidth(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(140),
      heightDimension: .absolute(186)
    )
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: FeedViewController.sectionHeaderElementKind,
      alignment: .top
    )

    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [sectionHeader]
    section.orthogonalScrollingBehavior = .groupPaging

    return section
  }

  func generateGridLayout(isWide: Bool) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

    let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: groupHeight
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: FeedViewController.sectionHeaderElementKind,
      alignment: .top
    )

    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [sectionHeader]

    return section
  }
}
