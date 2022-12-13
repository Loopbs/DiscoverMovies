//
//  TitlePreviewViewController.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit
import WebKit
import SnapKit

class TitlePreviewViewController: UIViewController {

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "God Father"
        return label
    }()

    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a mafia!"
        return label
    }()

    private let favoriteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Favorite", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        return button
    }()

    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(favoriteButton)
        view.addSubview(webView)

        configureContraints()
    }

    func configureContraints() {

        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(overviewLabel.snp.bottom).offset(25)
            make.width.equalTo(150)
        }
    }

    func configure(with model : TitlePreviewViewModel) {

        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview

        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
}
