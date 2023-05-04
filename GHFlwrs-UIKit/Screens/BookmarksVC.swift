//
//  BookmarksVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 25.04.2023.
//

import UIKit

class BookmarksVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
    }

    private func configureVC() {
        title = "Bookmarks"
    }

    private func getBookmarks() {
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
