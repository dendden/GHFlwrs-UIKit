//
//  FollowersListVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {

    enum Section {
        case main
    }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var userHasMoreFollowersToLoad = true
    var isLoadingMoreFollowers = false

    var bookmarkImage = SystemImages.bookmarkEmpty

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String) {
        super.init(nibName: nil, bundle: nil)

        self.username = username
        title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureSearchController()
        configureCollectionView()

        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureVC() {
        selectBookmarkImage()
        let bookmarkButton = UIBarButtonItem(
            image: bookmarkImage,
            style: .plain,
            target: self,
            action: #selector(bookmarkTapped)
        )
        navigationItem.rightBarButtonItem = bookmarkButton
    }

    private func selectBookmarkImage() {
        if PersistenceManager.allBookmarkedUsers.contains(username) {
            bookmarkImage = SystemImages.bookmarkFill
        } else {
            bookmarkImage = SystemImages.bookmarkEmpty
        }
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.makeThreeColumnFlowLayout(in: view)
        )
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Filter by username"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func manageSearchController(remove: Bool) {
        if remove {
            navigationItem.searchController = nil
        } else {
            if navigationItem.searchController == nil {
                configureSearchController()
            }
        }
    }

    private func getFollowers(username: String, page: Int) {

        showLoadingProgressView()

        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in

            guard let self = self else {
                return
            }

            self.dismissLoadingProgressView()

            switch result {
            case .success(let followers):
                if followers.count < NetworkManager.shared.followersPerPage {
                    self.userHasMoreFollowersToLoad = false
                }
                DispatchQueue.main.async {
                    self.followers.append(contentsOf: followers)
                    if self.followers.isEmpty {
                        let message = "This user doesn't have any followers yet. You can be the first! 🥹"
                        self.manageSearchController(remove: true)
                        self.showEmptyStateView(with: message, in: self.view)
                    } else {
                        self.manageSearchController(remove: false)
                        self.updateData(on: self.followers)
                    }
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Problem 🤦🏼‍♂️", message: error.rawValue) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.isLoadingMoreFollowers = false
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowerCell.reuseID,
                    for: indexPath
                ) as? FollowerCell else {
                    return nil
                }
                cell.set(follower: itemIdentifier)

                return cell
            }
    }

    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        dataSource.apply(snapshot, animatingDifferences: true)  // might need to dispatch to main if get warnings
    }

    @objc private func bookmarkTapped() {

        showLoadingProgressView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in

            guard let self = self else { return }

            self.dismissLoadingProgressView()

            switch result {
            case .success(let user):
                let bookmark = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(bookmark, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        self.presentGFAlertOnMainThread(title: "Bookmark Error", message: error.rawValue)
                    } else {
                        self.presentGFAlertOnMainThread(
                            title: "Nailed it 📌",
                            message: "You can now find \(user.login) in ⭐️ Favorites tab.",
                            buttonTitle: "Sweet") {
                                // update bookmark button appearance
                                self.configureVC()
                            }
                    }
                }
            case .failure:
                self.presentGFAlertOnMainThread(
                    title: "Bookmark Error",
                    message: "There's a problem retrieving sufficient user info to bookmark 🤷🏻‍♂️"
                )
            }
        }
    }
}

extension FollowersListVC: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offset > (contentHeight - screenHeight) && userHasMoreFollowersToLoad && !isLoadingMoreFollowers {
            isLoadingMoreFollowers = true
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var follower: Follower
        if !filteredFollowers.isEmpty {
            follower = filteredFollowers[indexPath.item]
        } else {
            follower = followers[indexPath.item]
        }

        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.userInfoDelegate = self
        let destinationNC = UINavigationController(rootViewController: destinationVC)
        present(destinationNC, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text
        else { return }

        if filter.trimmingCharacters(in: .whitespaces).isEmpty {
            if !filteredFollowers.isEmpty {
                // if search bar BECAME empty after previous filtering
                filteredFollowers.removeAll()
                updateData(on: followers)
                return
            } else {
                return
            }
        }

        filteredFollowers = followers.filter {
            $0.login.lowercased().contains(filter.lowercased())
        }

        updateData(on: filteredFollowers)
    }
}

extension FollowersListVC: UserInfoVCDelegate {

    func didRequestFollowersList(for username: String) {

        self.username = username
        title = username
        configureVC()   // this updates bookmark button
        page = 1
        userHasMoreFollowersToLoad  = true
        followers.removeAll()
        filteredFollowers.removeAll()
        navigationItem.searchController?.isActive = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        getFollowers(username: username, page: page)
    }
}
