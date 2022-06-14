//
//  AlbumsViewController.swift
//  PhotoGalleryProject
//
//  Created by Федор Донсков on 14.06.2022.
//

import UIKit

class AlbumsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
    }
    
    // MARK: - Setup Hierarchy
    func setupHierarchy() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Альбомы"
    }
}
