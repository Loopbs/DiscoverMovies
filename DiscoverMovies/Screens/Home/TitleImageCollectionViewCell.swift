//
//  TitleImageCollectionViewCell.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit

class TitleImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "TitleImageCollectionViewCell"

    private let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        posterImageView.frame = contentView.bounds
    }

    func configure(with model : String) {

        let urlString = Configuration.baseImageUrl + "/w500/\(model)"

        ImageDownloadManager.shared.downloadImage(imageView: posterImageView,
                                                  url: urlString,
                                                  profilePlaceHolderImage: #imageLiteral(resourceName: "netflix_logo.png"),
                                                  failureImage: nil,
                                                  isPrepareForReuse: true)
    }
}
