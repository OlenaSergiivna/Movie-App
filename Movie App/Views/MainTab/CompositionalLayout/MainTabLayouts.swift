//
//  Layouts.swift
//  Movie App
//
//  Created by user on 25.10.2022.
//

import UIKit

class MainTabLayouts {
    
    static let shared = MainTabLayouts()
    
    func popularNowSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        
//         PLay with some animation and scrollOffest
//        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
//            items.forEach { item in
//                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
//                let minScale: CGFloat = 0.8
//                let maxScale: CGFloat = 1.0
//                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
//                item.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }
//        }

        
        return section
    }
    
//    func moviesSection()-> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .absolute(90))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
//        section.orthogonalScrollingBehavior = .continuous
//
//        return section
//    }
    
    func moviesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: "Header", alignment: .top),
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: "Footer", alignment: .bottom)
            
        ]
        
        return section
    }
    
//    func VeganSectionLayout() -> NSCollectionLayoutSection {
//        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(170), heightDimension: .absolute(260)), subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 60, trailing: -10)
//        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//
//        section.boundarySupplementaryItems = [
//            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), elementKind: "Header", alignment: .top),
//        ]
//
//        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: "SectionBackground")
//        section.decorationItems = [decorationItem]
//
//        return section
//    }
}

