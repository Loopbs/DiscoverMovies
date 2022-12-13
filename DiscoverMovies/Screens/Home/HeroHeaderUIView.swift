//
//  HeroHeaderUIView.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit

class HeroHeaderUIView: UIView {

    private let heroImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {

        super.init(frame: frame)

        addSubview(heroImageView)
        addGradient()
    }

    private func addGradient() {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    func configure(with model : TitleViewModel) {

        let urlString = Configuration.baseImageUrl + "/w500/\(model.posterURL)"

        ImageDownloadManager.shared.downloadImage(imageView: heroImageView,
                                                  url: urlString,
                                                  profilePlaceHolderImage: #imageLiteral(resourceName: "netflix_logo.png"),
                                                  failureImage: nil,
                                                  isPrepareForReuse: true)
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        heroImageView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
