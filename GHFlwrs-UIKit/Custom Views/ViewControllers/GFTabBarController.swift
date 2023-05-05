//
//  GFTabBarController.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 05.05.2023.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
    }

    /// Configures Tab bar with tint color of `green` and ViewControllers of [SearchNC, FavoritesNC].
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = .systemGreen

        configureNavigationBar()

        viewControllers = [makeSearchNC(), makeFavoritesNC()]
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = .systemGreen
    }

    /// Creates a `NavigationController` setup with Search ViewController as root, including title
    /// "Search" and `UITabBarItem` set to `.search`.
    /// - Returns: A `NavigationController` with `SearchVC` set as its root.
    private func makeSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchVC)
    }

    /// Creates a `NavigationController` setup with Favorites ViewController as root, including title
    /// "Favorites" and `UITabBarItem` set to `.favorites`.
    /// - Returns: A `NavigationController` with `FavoritesVC` set as its root.
    private func makeFavoritesNC() -> UINavigationController {
        let favoritesVC = BookmarksVC()
        favoritesVC.title = "Bookmarks"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)

        return UINavigationController(rootViewController: favoritesVC)
    }

}
