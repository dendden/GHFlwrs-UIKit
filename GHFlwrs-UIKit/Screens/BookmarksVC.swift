//
//  BookmarksVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 25.04.2023.
//

import UIKit

/// A `ViewController` that interacts with ``PersistenceManager`` for listing
/// all bookmarked users in a `UITableView` of ``BookmarkCell`` and deleting
/// individual bookmarks.
///
/// If there are no bookmarked users - this controller displays an empty state view.
class BookmarksVC: GFDataLoadingVC {

    /// An array of bookmarked users.
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

    /// Calls ``PersistenceManager``.``PersistenceManager/retrieveBookmarks(completion:)``
    /// method.
    ///
    /// If retrieve request fails - this method presents a ``GFAlertVC`` with ``GFPersistenceError`` description.
    ///
    /// If request returns an empty array - empty state view is displayed.
    ///
    /// If request is successful - this method assigns ``bookmarks`` variable and updates `UITableView`
    /// with bookmarks data.
    private func getBookmarks() {
        PersistenceManager.retrieveBookmarks { [weak self] result in

            guard let self else { return }

            switch result {
            case .success(let bookmarks):
                self.updateUI(with: bookmarks)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Bookmarking is hard!", message: error.rawValue)
                }
            }
        }
    }

    /// Updates the `UITableView` if fetched bookmarks are not empty, otherwise
    /// displays empty state view.
    /// - Parameter bookmarks: An array of bookmarked users, fetched from persistent storage.
    private func updateUI(with bookmarks: [Follower]) {
        if bookmarks.isEmpty {
            showEmptyStateView(with: "Your bookmarked users will appear here.", in: self.view)
        } else {
            DispatchQueue.main.async {
                self.bookmarks = bookmarks
                self.tableView.reloadData()
                // if empty state was showing, move TV on top of it
                self.view.bringSubviewToFront(self.tableView)
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

            guard let self else { return }

            DispatchQueue.main.async {
                if let error {
                    self.presentGFAlert(title: "Not really", message: error.rawValue)
                } else {
                    self.bookmarks.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
