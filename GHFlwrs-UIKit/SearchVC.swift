//
//  SearchVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 25.04.2023.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let usernameSearchField = GFSearchField()
    let searchButton = GFButton(buttonColor: .systemGreen, title: "Get Followers")

    var isUsernameEntered: Bool {
        if let searchFieldText = usernameSearchField.text {
            return !searchFieldText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureLogoImageView()
        configureSearchField()
        configureSearchButton()

        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tap )
    }

    @objc func pushFollowersListVC() {

        guard isUsernameEntered else { return }

        let followersListVC = FollowersListVC()
        followersListVC.username = usernameSearchField.text
        followersListVC.title = usernameSearchField.text

        navigationController?.pushViewController(followersListVC, animated: true)
    }

    /// Adds `logoImageView` to parent view, assigns the image and activates
    /// layout constraints.
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 1)
        ])
    }

    func configureSearchField() {
        view.addSubview(usernameSearchField)
        // listen for Return key hit to perform action:
        usernameSearchField.delegate = self

        NSLayoutConstraint.activate([
            usernameSearchField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameSearchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameSearchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameSearchField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SearchVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        pushFollowersListVC()
        return true
    }
}
