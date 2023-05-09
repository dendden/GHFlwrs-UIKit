//
//  SearchVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 25.04.2023.
//

import UIKit

/// Initial `ViewController` of a `Search` tab, containing a ``GFSearchField``
/// and a ``GFButton`` that pushes ``FollowersListVC`` with search results
/// onto   `NavigationController` stack.
class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let usernameSearchField = GFSearchField()
    let searchButton = GFButton(color: .systemGreen, title: "Get Followers")

    /// A variable that checks whether any characters except white spaces were
    /// entered into the search field.
    var isUsernameEntered: Bool {
        if let searchFieldText = usernameSearchField.text {
            return !searchFieldText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameSearchField, searchButton)

        configureLogoImageView()
        configureSearchField()
        configureSearchButton()

        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameSearchField.text = ""
    }

    /// Adds a tap gesture that dismisses keyboard to the view.
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tap)
    }

    /// Dismisses keyboard and checks ``isUsernameEntered`` variable:
    /// if true, a ``FollowersListVC`` with entered username is created and
    /// pushed onto `NavigationController`. If false, an alert is shown.
    @objc private func pushFollowersListVC() {

        view.endEditing(true)   // dismiss keyboard

        guard isUsernameEntered else {
            presentGFAlert(
                title: "Username No-No",
                message: "Looks like you forgot to input anything except emptiness in that search field 🥺.",
                haptic: .error
            )
            return
        }

        let followersListVC = FollowersListVC(username: usernameSearchField.text!)

        navigationController?.pushViewController(followersListVC, animated: true)
    }

    /// Adds `logoImageView` to parent view, assigns the image and activates
    /// layout constraints.
    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo

        var topConstraintConstant: CGFloat = 80
        if DeviceTypes.iPhone8 {
            topConstraintConstant = 25
        }
        if DeviceTypes.iPhone8Plus {
            topConstraintConstant = 40
        }
        if DeviceTypes.iPhone13Mini || DeviceTypes.iPhone11Pro {
            topConstraintConstant = 60
        }

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: topConstraintConstant
            ),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 1)
        ])
    }

    /// Assigns self as a `UITextFieldDelegate` for ``usernameSearchField``,
    /// activates constraints for search field.
    private func configureSearchField() {
        // listen for Return key hit to perform action:
        usernameSearchField.delegate = self

        NSLayoutConstraint.activate([
            usernameSearchField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameSearchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameSearchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameSearchField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    /// Configures ``searchButton`` with an action to call `pushFollowersListVC()`
    /// method, activates layout constraints for the ``searchButton``.
    private func configureSearchButton() {
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
