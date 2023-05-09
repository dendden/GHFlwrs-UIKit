//
//  FollowersListVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

/// A `ViewController` that performs a network request to get
/// user's followers and displays them in a `UICollectionView`.
///
/// In `UICollectionView`, each follower is presented in a ``FollowerCell``.
/// If request returns an empty list, this controller displays an empty state view.
/// If network request fails, this controller presents a ``GFAlertVC`` and
/// dismisses itself from `NavigationController`, returning to ``SearchVC``.
class FollowersListVC: GFDataLoadingVC {

    enum Section {
        case main
    }

    // MARK: - Class variables

    /// A username of user, whose followers must be displayed.
    var username: String!

    /// All currently loaded users.
    var followers: [Follower] = []

    /// Followers that match filter in `SearchController`.
    var filteredFollowers: [Follower] = []

    /// The page of results returned from network request.
    ///
    /// Number of results per page is defined in ``NetworkManager``.``NetworkManager/followersPerPage``.
    var page = 1

    /// An indicator for whether more pages of followers can be loaded for user.
    ///
    /// If network request for current ``page`` returns less than ``NetworkManager/followersPerPage``
    /// followers, this indicator is set to false, otherwise stays true.
    var userHasMoreFollowersToLoad = true

    /// An indicator of ongoing network request.
    ///
    /// This indicator prevents multiple calls to ``NetworkManager`` for incrementing ``page`` values
    /// if user hits bottom of `UICollectionView` and pulls multiple times to load more followers.
    var isLoadingMoreFollowers = false

    // MARK: - View variables

    /// An image for `bookmark` toolbar button.
    var bookmarkImage = SystemImages.bookmarkEmpty
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    // MARK: -
    /// Creates an instance of ``FollowersListVC``.
    /// - Parameter username: A username for user, whose followers must be
    /// displayed
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

        configureSearchController()
        configureCollectionView()

        getFollowers()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        configureBookmarkButton()
    }

    /// Configures and adds bookmark button to the navigation toolbar.
    private func configureBookmarkButton() {
        selectBookmarkImage()
        let bookmarkButton = UIBarButtonItem(
            image: bookmarkImage,
            style: .plain,
            target: self,
            action: #selector(bookmarkTapped)
        )
        navigationItem.rightBarButtonItem = bookmarkButton
    }

    /// Checks ``username`` against the ``PersistenceManager``.``PersistenceManager/allBookmarkedUsers``
    /// array of usernames and sets bookmark image that corresponds to user's bookmarked status.
    private func selectBookmarkImage() {
        if PersistenceManager.allBookmarkedUsers.contains(username.lowercased()) {
            bookmarkImage = SystemImages.bookmarkFill
        } else {
            bookmarkImage = SystemImages.bookmarkEmpty
        }
    }

    /// Sets a 3-column `FlowLayout` for the collection view, adds it as a subview, sets `self`
    /// for the delegate and registers ``FollowerCell``.
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

    /// Removes or re-instates the `searchController` from `navigationItem`.
    ///
    /// This method is called from the result of network call for followers - if followers list
    /// is empty, `searchController` is hidden, else returned.
    /// - Parameter remove: Indicator whether `searchController` must be
    /// removed from `navigationItem`.
    private func manageSearchController(remove: Bool) {
        if remove {
            navigationItem.searchController = nil
        } else {
            if navigationItem.searchController == nil {
                configureSearchController()
            }
        }
    }

    /// Performs a network call with ``NetworkManager``.``NetworkManager/getFollowers(for:page:)``
    /// method.
    ///
    /// This method also shows `ProgressLoadingView` prior to network call and hides it once
    /// the call returns a result.
    /// - Parameters:
    ///   - username: A username of user, whose followers must be retrieved via a network request.
    ///   - page: The page for fetch results.
    private func getFollowers() {

        showLoadingProgressView()
        Task {
            do {
                try await requestFollowers(username: username, page: page)
            } catch {
                presentNetworkError(error) {
                    if self.followers.isEmpty {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            isLoadingMoreFollowers = false
        }

        /* Old way of performing network call (with completion handler + Result type): */
        /*NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in

            guard let self = self else { return }

            self.dismissLoadingProgressView()

            switch result {
            case .success(let followers):
                if followers.count < NetworkManager.shared.followersPerPage {
                    self.userHasMoreFollowersToLoad = false
                }
                self.updateUIOnMainThread(with: followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Problem 🤦🏼‍♂️", message: error.rawValue) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.isLoadingMoreFollowers = false
        } */
    }

    /// Calls the ``NetworkManager``.``NetworkManager/getFollowers(for:page:)``
    /// method and updates UI with if request was successful.
    private func requestFollowers(username: String, page: Int) async throws {
        let fetchedFollowers = try await NetworkManager.shared.getFollowers(for: username, page: page)
        updateUI(with: fetchedFollowers)
        dismissLoadingProgressView()
    }

    /// Accepts new array of followers from a network call and appends it
    /// to own ``followers`` array, then updates UI depending on
    /// whether ``followers`` array is empty or not.
    /// - Parameter followers: A new array of followers to append to
    /// existing array.
    private func updateUI(with followers: [Follower]) {
        if followers.count < NetworkManager.shared.followersPerPage {
            userHasMoreFollowersToLoad = false
        }
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers yet. You can be the first! 🥹"
            manageSearchController(remove: true)
            showEmptyStateView(with: message, in: self.view)
        } else {
            manageSearchController(remove: false)
            updateData(on: self.followers)
        }
    }

    /// Configures the `UICollectionViewDiffableDataSource` by calling
    /// `.dequeueReusableCell(withReuseIdentifier:)` and assigning
    /// ``Follower`` to the ``FollowerCell`` with its ``FollowerCell/set(follower:)``
    /// method.
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

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    /// Fetches user info with ``NetworkManager``. ``NetworkManager/getUserInfo(for:)``
    /// method and calls ``PersistenceManager``.``PersistenceManager/updateWith(_:actionType:completion:)``
    /// to check for user's bookmarked status and add this user to bookmarks or show alert
    /// informing that current user is already bookmarked.
    ///
    /// This method also  shows `ProgressLoadingView` prior to network call and hides it once
    /// the call returns a result.
    @objc private func bookmarkTapped() {

        showLoadingProgressView()

        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                dismissLoadingProgressView()
                bookmarkUser(user)
            } catch {
                dismissLoadingProgressView()
                presentGFAlert(
                    title: "Bookmark Error",
                    message: "There's a problem retrieving sufficient user info to bookmark 🤷🏻‍♂️",
                    haptic: .error
                )
            }
        }

        /* Old way of performing network call (with completion handler + Result type): */
        /*NetworkManager.shared.getUserInfo(for: username) { [weak self] result in

            guard let self = self else { return }

            self.dismissLoadingProgressView()

            switch result {
            case .success(let user):
                self.bookmarkUser(user)
            case .failure:
                self.presentGFAlert(
                    title: "Bookmark Error",
                    message: "There's a problem retrieving sufficient user info to bookmark 🤷🏻‍♂️"
                )
            }
        }*/
    }

    /// Creates a ``Follower`` object from provided user and calls
    /// ``PersistenceManager``.``PersistenceManager/updateWith(_:actionType:completion:)``
    /// method to try and add this user to bookmarked.
    /// - Parameter user: A user who should be bookmarked.
    private func bookmarkUser(_ user: User) {
        let bookmark = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(bookmark, actionType: .add) { [weak self] error in
            guard let self else { return }
            if let error {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Bookmark Error", message: error.rawValue, haptic: .error)
                }
            } else {
                DispatchQueue.main.async {
                    self.presentGFAlert(
                        title: "Nailed it 📌",
                        message: "You can now find \(user.login) in 📖 Bookmarks tab.",
                        buttonTitle: "Sweet",
                        haptic: .success
                    ) {
                            // update bookmark button appearance
                            self.configureBookmarkButton()
                        }
                }
            }
        }
    }
}
// MARK: -

extension FollowersListVC: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offset > (contentHeight - screenHeight) && userHasMoreFollowersToLoad && !isLoadingMoreFollowers {
            isLoadingMoreFollowers = true
            page += 1
            getFollowers()
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
        guard let filter = searchController.searchBar.text else { return }

        if filter.trimmingCharacters(in: .whitespaces).isEmpty {
            if !filteredFollowers.isEmpty {
                // if search bar BECAME empty after previous filtering
                filteredFollowers.removeAll()
                updateData(on: followers)
                return
            } else { return }
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
        configureBookmarkButton()   // this updates bookmark button
        page = 1
        userHasMoreFollowersToLoad  = true
        followers.removeAll()
        filteredFollowers.removeAll()
        navigationItem.searchController?.isActive = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        getFollowers()
    }
}
