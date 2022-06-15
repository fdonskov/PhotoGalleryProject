//
//  AlbumConfigurationViewController.swift
//  PhotoGalleryProject
//
//  Created by Федор Донсков on 14.06.2022.
//

import UIKit

class AlbumConfigurationViewController: UIViewController {
    
    var detailCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reuseId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        detailCollectionView = collectionView
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                                                                 heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                                                heightDimension: .fractionalHeight(1.0)),
                                                             subitem: pairItem,
                                                             count: 2)
        
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                      heightDimension: .fractionalWidth(4/9)),
                                                                   subitems: [mainItem, trailingGroup])
        
        let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                                    heightDimension: .fractionalHeight(1.0)))
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                 heightDimension: .fractionalWidth(2/9)),
                                                              subitems: [tripletItem, tripletItem, tripletItem])
        
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                              heightDimension: .fractionalWidth(4/9)),
                                                                           subitems: [trailingGroup, mainItem])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalWidth(16/9)),
                                                           subitems: [mainWithPairGroup, tripletGroup, mainWithPairReversedGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension AlbumConfigurationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album?.album.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCell.reuseId, for: indexPath) as! TypeCell
        cell.imageView.image = album?.album[indexPath.row].image
        return cell
    }
}

