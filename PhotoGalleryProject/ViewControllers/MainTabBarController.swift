//
//  MainTabBarController.swift
//  PhotoGalleryProject
//
//  Created by Федор Донсков on 14.06.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateTabBarController()
    }
    
    // MARK: - configurateTabBarController
    func configurateTabBarController() {
        let mediaViewController = MediaViewController()
        let forYouViewController = ForYouViewController()
        let albumsViewController = AlbumsViewController()
        let searchViewController = SearchViewController()
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let mediaImage = UIImage(systemName: "photo.fill.on.rectangle.fill", withConfiguration: boldConfig)!
        let forYouImage = UIImage(systemName: "heart.text.square.fill", withConfiguration: boldConfig)!
        let albumImage = UIImage(systemName: "rectangle.stack.fill", withConfiguration: boldConfig)!
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: mediaViewController, title: "Медиатека", image: mediaImage),
            generateNavigationController(rootViewController: forYouViewController, title: "Для Вас", image: forYouImage),
            generateNavigationController(rootViewController: albumsViewController, title: "Альбомы", image: albumImage),
            generateNavigationController(rootViewController: searchViewController, title: "Поиск", image: searchImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
    
}
