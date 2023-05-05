//
//  GFAvatarImageView.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = Images.placeholder
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

    func downloadImage(from urlString: String) {

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
