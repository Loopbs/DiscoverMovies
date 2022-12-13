//
//  TitlePreviewViewController.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit
import WebKit

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

        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]

        let titleLabelConstratints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]

        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        let favoriteButtonConstraints = [
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            favoriteButton.widthAnchor.constraint(equalToConstant: 150)
        ]

        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstratints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(favoriteButtonConstraints)
    }

    func configure(with model : TitlePreviewViewModel) {

        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview

        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
}
