//
//  TitleTableViewCell.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier : String = "TitleTableViewCell"

    private let playTitleButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()

    private let titleLAbel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titlesPosterUIImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLAbel)
        contentView.addSubview(playTitleButton)

        applyConstraints()
    }

    private func  applyConstraints() {

        let titlesPosterUIImageViewConstraints = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]

        let titleLabelConstaints = [
            titleLAbel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor,constant: 20),
            titleLAbel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstaints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }

    func configure(with model : TitleViewModel) {


        let urlString = Configuration.baseImageUrl + "/w500/\(model.posterURL)"

        ImageDownloadManager.shared.downloadImage(imageView: titlesPosterUIImageView,
                                                  url: urlString,
                                                  profilePlaceHolderImage: #imageLiteral(resourceName: "netflix_logo.png"),
                                                  failureImage: nil,
                                                  isPrepareForReuse: true)
        titleLAbel.text = model.titleName
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
