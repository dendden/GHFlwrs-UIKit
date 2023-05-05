//
//  BookmarksVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 25.04.2023.
//

import UIKit

class BookmarksVC: UIViewController {

    var bookmarks: [Follower] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getBookmarks()
    }

    private func configureVC() {
        title = "Bookmarks"
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.reuseID)
    }

    private func getBookmarks() {
        PersistenceManager.retrieveBookmarks { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let bookmarks):
                if bookmarks.isEmpty {
                    self.showEmptyStateView(with: "Your bookmarked users will appear here.", in: self.view)
                } else {
                    DispatchQueue.main.async {
                        self.bookmarks = bookmarks
                        self.tableView.reloadData()
                        // if empty state was showing, move TV on top of it
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bookmarking is hard!", message: error.rawValue)
            }
        }
    }
}

extension BookmarksVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.reuseID) as? BookmarkCell else {
            return UITableViewCell()
        }
        let bookmark = bookmarks[indexPath.row]
        cell.set(bookmark: bookmark)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = bookmarks[indexPath.row]
        let destinationVC = FollowersListVC(username: bookmark.login)

        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        let bookmark = bookmarks[indexPath.row]

        PersistenceManager.updateWith(bookmark, actionType: .remove) { [weak self] error in

            guard let self = self else { return }

            if let error = error {
                self.presentGFAlertOnMainThread(title: "Not really", message: error.rawValue)
            } else {
                self.bookmarks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
