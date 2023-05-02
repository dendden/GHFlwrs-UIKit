//
//  FollowersListVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

class FollowersListVC: UIViewController {

    enum Section {
        case main
    }

    var username: String!
    var followers: [Follower] = []
    var page = 1
    var userHasMoreFollowersToLoad = true

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureCollectionView()

        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureVC() {
        view.backgroundColor = .systemBackground
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
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    self.updateData()
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Problem 🤦🏼‍♂️", message: error.rawValue) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
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

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        dataSource.apply(snapshot, animatingDifferences: true)  // might need to dispatch to main if get warnings
    }
}

extension FollowersListVC: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offset > (contentHeight - screenHeight) && userHasMoreFollowersToLoad {
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}
