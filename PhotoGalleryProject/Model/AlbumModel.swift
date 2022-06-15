//
//  AlbumModel.swift
//  PhotoGalleryProject
//
//  Created by Федор Донсков on 14.06.2022.
//

import UIKit

struct Albums: Hashable {
    var section: Sections
    var album: [Album]
    var name: String
    var icon: UIImage?
}

struct Album: Hashable {
    var image: UIImage?
}

enum Sections: String, CaseIterable {
    case myAlbums = "Мои альбомы"
    case peopleAndPlacesAlbums = "Люди и места"
    case mediaTypes = "Типы медиафайлов"
    case other = "Другое"
}

struct OtherAlbums: Hashable {
    var icon: UIImage?
    var name: String
}
