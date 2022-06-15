//
//  AlbumsViewController.swift
//  PhotoGalleryProject
//
//  Created by Федор Донсков on 14.06.2022.
//

import UIKit

var myAlbums = [Albums]()
var peopleAndPlacesAlbums = [Albums]()
var mediaTypes = [Albums]()
var other = [Albums]()
var album: Albums?

class AlbumsViewController: UIViewController {
    
    static let sectionHeaderName = "sectionHeaderName"
    var albumsCollectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Sections, Albums>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
    }
    
    // MARK: - Setup Hierarchy
    func setupHierarchy() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Альбомы"
        configureButtonAdd()
        appendItems()
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: - Create Add button toolBar
    private func configureButtonAdd() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    // MARK: - Configure CollcetionView
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        
        collectionView.register(AlbumPhotoCell.self, forCellWithReuseIdentifier: AlbumPhotoCell.reuseId)
        collectionView.register(OtherCell.self, forCellWithReuseIdentifier: OtherCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: AlbumsViewController.sectionHeaderName, withReuseIdentifier: SectionHeader.reuseId)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        albumsCollectionView = collectionView
    }
    
    // MARK: - Configure CollcetionViewDiffableDataSource
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, Albums>(collectionView: albumsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, albumItem: Albums) -> UICollectionViewListCell? in
            let sectionType = Sections.allCases[indexPath.section]
            
            switch sectionType {
            case .myAlbums:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumPhotoCell.reuseId, for: indexPath) as! AlbumPhotoCell
                cell.titleLabel.text = myAlbums[indexPath.row].name
                cell.itemsCountLabel.text = String(myAlbums[indexPath.row].album.count)
                cell.foregroundView.image = myAlbums[indexPath.row].album.last?.image
                return cell
            case .peopleAndPlacesAlbums:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumPhotoCell.reuseId, for: indexPath) as! AlbumPhotoCell
                cell.titleLabel.text = peopleAndPlacesAlbums[indexPath.row].name
                cell.itemsCountLabel.text = String(peopleAndPlacesAlbums[indexPath.row].album.count)
                cell.foregroundView.image = peopleAndPlacesAlbums[indexPath.row].album.last?.image
                return cell
            case .mediaTypes:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherCell.reuseId, for: indexPath) as! OtherCell
                cell.nameLabel.text = mediaTypes[indexPath.row].name
                cell.imageView.image = mediaTypes[indexPath.row].icon
                return cell
            case .other:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherCell.reuseId, for: indexPath) as! OtherCell
                cell.nameLabel.text = other[indexPath.row].name
                cell.imageView.image = other[indexPath.row].icon
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create header view") }
            
            supplementaryView.label.text = Sections.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Sections, Albums> {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Albums>()
        snapshot.appendSections([Sections.myAlbums])
        snapshot.appendItems(myAlbums)
        snapshot.appendSections([Sections.peopleAndPlacesAlbums])
        snapshot.appendItems(peopleAndPlacesAlbums)
        snapshot.appendSections([Sections.mediaTypes])
        snapshot.appendItems(mediaTypes)
        snapshot.appendSections([Sections.other])
        snapshot.appendItems(other)
        return snapshot
    }
    
    let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: AlbumsViewController.sectionHeaderName,
                                                                        alignment: .top)
        
        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    // MARK: - Custom Layouts
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: AlbumsViewController.sectionHeaderName,
                                                                            alignment: .top)
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.boundarySupplementaryItems = [sectionHeader]
            
            let sectionLayout = Sections.allCases[sectionIndex]
            
            switch sectionLayout {
            case .myAlbums: return self.configureMyAlbumsLayout()
            case .peopleAndPlacesAlbums: return self.configurePeopleAndPlacesAlbumsLayout()
            case.mediaTypes: return section
            case .other: return section
            }
        }
        return layout
    }
    
    func configureMyAlbumsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                               heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: AlbumsViewController.sectionHeaderName,
                                                                        alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func configurePeopleAndPlacesAlbumsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: AlbumsViewController.sectionHeaderName,
                                                                        alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func configureMediaTypesLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 6)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: AlbumsViewController.sectionHeaderName,
                                                                        alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}

// MARK: - UICollectionViewDelegate
extension AlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        album = item
        let controller = AlbumConfigurationViewController()
        navigationController?.pushViewController(controller, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - appendItems
extension AlbumsViewController {
    func appendItems() {
        myAlbums.append(Albums(section: .myAlbums, album: [Album(image: UIImage(named: "selfie1")),
                                                           Album(image: UIImage(named: "selfie2")),
                                                           Album(image: UIImage(named: "selfie3")),
                                                           Album(image: UIImage(named: "selfie4")),
                                                           Album(image: UIImage(named: "selfie5"))
                                                          ], name: "Недавние"))
        
        myAlbums.append(Albums(section: .myAlbums, album: [Album(image: UIImage(named: "ios1")),
                                                           Album(image: UIImage(named: "ios2"))
                                                          ], name: "Избранное"))
        
        myAlbums.append(Albums(section: .myAlbums, album: [Album(image: UIImage(named: "nature1")),
                                                           Album(image: UIImage(named: "nature2")),
                                                           Album(image: UIImage(named: "nature3")),
                                                           Album(image: UIImage(named: "nature4")),
                                                           Album(image: UIImage(named: "nature5"))
                                                          ], name: "Природа"))
        
        myAlbums.append(Albums(section: .myAlbums, album: [Album(image: UIImage(named: "inst1")),
                                                           Album(image: UIImage(named: "inst2")),
                                                           Album(image: UIImage(named: "inst3"))
                                                          ], name: "Instagram"))
        
        myAlbums.append(Albums(section: .myAlbums, album: [Album(image: UIImage(named: "tes1")),
                                                           Album(image: UIImage(named: "tes2")),
                                                           Album(image: UIImage(named: "tes3")),
                                                           Album(image: UIImage(named: "tes4")),
                                                           Album(image: UIImage(named: "tes5")),
                                                           Album(image: UIImage(named: "tes6"))
                                                          ], name: "Автомобили"))
        
        peopleAndPlacesAlbums.append(Albums(section: .peopleAndPlacesAlbums, album: [Album(image: UIImage(named: "people1")),
                                                                                     Album(image: UIImage(named: "people2")),
                                                                                     Album(image: UIImage(named: "people3"))
                                                                                    ], name: "Люди"))
        
        peopleAndPlacesAlbums.append(Albums(section: .peopleAndPlacesAlbums, album: [Album(image: UIImage(named: "map1")),
                                                                                     Album(image: UIImage(named: "map2")),
                                                                                     Album(image: UIImage(named: "map3"))
                                                                                    ], name: "Места"))
        
        peopleAndPlacesAlbums.append(Albums(section: .peopleAndPlacesAlbums, album: [Album(image: UIImage(named: "detal1")),
                                                                                     Album(image: UIImage(named: "detal2"))
                                                                                    ], name: "Запчасти"))
        
        peopleAndPlacesAlbums.append(Albums(section: .peopleAndPlacesAlbums, album: [Album(image: UIImage(named: "comp"))
                                                                                    ], name: "ПК"))
        
        peopleAndPlacesAlbums.append(Albums(section: .peopleAndPlacesAlbums, album: [Album(image: UIImage(named: "dev1")),
                                                                                     Album(image: UIImage(named: "dev2"))
                                                                                    ], name: "Разработка"))
        
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "nature1")),
                                                               Album(image: UIImage(named: "nature2")),
                                                               Album(image: UIImage(named: "nature3")),
                                                               Album(image: UIImage(named: "nature4")),
                                                               Album(image: UIImage(named: "nature5"))
                                                              ], name: "Видео", icon: UIImage(systemName: "video")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "people1")),
                                                               Album(image: UIImage(named: "people2")),
                                                               Album(image: UIImage(named: "people3"))
                                                              ], name: "Селфи", icon: UIImage(systemName: "person.crop.rectangle")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "selfie1")),
                                                               Album(image: UIImage(named: "selfie2")),
                                                               Album(image: UIImage(named: "selfie3"))
                                                              ], name: "Фото Live Photos", icon: UIImage(systemName: "livephoto")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "portr1")),
                                                               Album(image: UIImage(named: "portr2")),
                                                               Album(image: UIImage(named: "portr3"))
                                                              ], name: "Портреты", icon: UIImage(systemName: "cube")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "time1")),
                                                               Album(image: UIImage(named: "time2")),
                                                               Album(image: UIImage(named: "time3"))
                                                              ], name: "Таймлапс", icon: UIImage(systemName: "timelapse")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "map1")),
                                                               Album(image: UIImage(named: "map2")),
                                                               Album(image: UIImage(named: "map3"))
                                                              ], name: "Снимки экрана", icon: UIImage(systemName: "camera.viewfinder")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "inst1")),
                                                               Album(image: UIImage(named: "inst2")),
                                                               Album(image: UIImage(named: "inst3"))
                                                              ], name: "Записи экрана", icon: UIImage(systemName: "record.circle")))
        mediaTypes.append(Albums(section: .mediaTypes, album: [Album(image: UIImage(named: "tes1")),
                                                               Album(image: UIImage(named: "tes2")),
                                                               Album(image: UIImage(named: "tes3"))
                                                              ], name: "Анимированные", icon: UIImage(systemName: "square.stack.3d.forward.dottedline")))
        
        other.append(Albums(section: .other, album: [Album(image: UIImage(named: "tes4")),
                                                     Album(image: UIImage(named: "tes5")),
                                                     Album(image: UIImage(named: "tes6"))
                                                    ], name: "Импортированные", icon: UIImage(systemName: "square.and.arrow.down")))
        other.append(Albums(section: .other, album: [Album(image: UIImage(named: "nature3")),
                                                     Album(image: UIImage(named: "nature4")),
                                                     Album(image: UIImage(named: "nature5"))
                                                    ], name: "Скрытые", icon: UIImage(systemName: "eye.slash")))
        other.append(Albums(section: .other, album: [Album(image: UIImage(named: "deleted1")),
                                                     Album(image: UIImage(named: "deleted2")),
                                                     Album(image: UIImage(named: "deleted3"))
                                                    ], name: "Недавно удаленные", icon: UIImage(systemName: "trash")))
    }
}

