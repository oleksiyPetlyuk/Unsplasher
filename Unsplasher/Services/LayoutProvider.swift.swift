//
//  LayoutProvider.swift.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 15.11.2021.
//

import UIKit

let layoutProvider = LayoutProvider()

class LayoutProvider {
  func fullWidthLayout(isWide: Bool, supplementaryElementKind: String? = nil) -> NSCollectionLayoutSection {
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

    let section = NSCollectionLayoutSection(group: group)

    if let supplementaryElementKind = supplementaryElementKind {
      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: supplementaryElementKind,
        alignment: .top
      )

      section.boundarySupplementaryItems = [sectionHeader]
    }

    section.orthogonalScrollingBehavior = .groupPaging

    return section
  }

  func thirdWidthLayout(supplementaryElementKind: String? = nil) -> NSCollectionLayoutSection {
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

    let section = NSCollectionLayoutSection(group: group)

    if let supplementaryElementKind = supplementaryElementKind {
      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: supplementaryElementKind,
        alignment: .top
      )

      section.boundarySupplementaryItems = [sectionHeader]
    }

    section.orthogonalScrollingBehavior = .groupPaging

    return section
  }

  func gridLayout(isWide: Bool, supplementaryElementKind: String? = nil) -> NSCollectionLayoutSection {
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

    let section = NSCollectionLayoutSection(group: group)

    if let supplementaryElementKind = supplementaryElementKind {
      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: supplementaryElementKind,
        alignment: .top
      )

      section.boundarySupplementaryItems = [sectionHeader]
    }

    return section
  }
}
