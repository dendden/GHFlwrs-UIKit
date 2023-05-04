//
//  FavoritesVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 25.04.2023.
//

import UIKit

class FavoritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink

        PersistenceManager.retrieveBookmarks { result in
            switch result {
            case .success(let bookmarks):
                for bookmark in bookmarks {
                    print(bookmark)
                }
            case .failure:
                break
            }
        }
    }

}
