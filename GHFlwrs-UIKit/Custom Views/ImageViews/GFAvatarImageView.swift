//
//  GFAvatarImageView.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import UIKit

/// A custom-configured `UIImageView` for displaying user avatar images.
///
/// Includes a `cornerRadius` of 10 pts and a default ``Images/placeholder`` image.
class GFAvatarImageView: UIImageView {

    /// A default image to display when image failed to load from `URL`.
    let placeholderImage = Images.placeholder

    /// ``NetworkManager`` ``NetworkManager/cache`` for storing downloaded avatar images.
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true    // without this setting image would ignore rounded corners of view
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Calls ``NetworkManager``.``NetworkManager/downloadImage(from:completion:)``
    /// method and assigns retrieved image to `self` on **main thread** if request was successful.
    ///
    /// If network request for image fails, this view displays ``Images/placeholder`` image.
    /// - Parameter urlString: A `String` representation of image `URL`.
    func downloadImage(fromURL urlString: String) {

        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in

            guard let self = self else { return }

            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }

}
