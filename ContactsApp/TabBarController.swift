//
//  TabViewController.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private enum TabBarItem {
        case contacts
        case favorite
        
        var iconName: String {
            switch self {
            case .contacts:
                return "person"
            case .favorite:
                return "heart"
            }
        }
        
        var selectedIconName: String {
            switch self {
            case .contacts:
                return "person.fill"
            case .favorite:
                return "heart.fill"
            }
        }
        
        var title: String {
            switch self {
            case .contacts:
                return "Контакты"
            case .favorite:
                return "Избранные"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        let datasource: [TabBarItem] = [.contacts, .favorite]
        
        self.viewControllers = datasource.map {
            switch $0 {
            case .contacts:
                let contactsViewController = UINavigationController(rootViewController: ModelBuilder.createContactModule())
                return contactsViewController
            case .favorite:
                let favoriteViewController = FavoriteViewController()
                return favoriteViewController
            }
        }

        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = datasource[$0].title
            $1.tabBarItem.image = UIImage(systemName: datasource[$0].iconName)
            $1.tabBarItem.selectedImage = UIImage(systemName: datasource[$0].selectedIconName)
        }
        

    }
}
