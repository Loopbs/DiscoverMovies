//
//  CollectionTableViewCell.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {

    func collectionViewTableCellDidTapCell(_ cell : CollectionTableViewCell, viewModel : TitlePreviewViewModel)
}

class CollectionTableViewCell: UITableViewCell {

    static let identifier = "CollectionTableViewCell"
    weak var delegate: CollectionTableViewCellDelegate?

    private var titles:[MovieModel]=[MovieModel]()
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)

        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleImageCollectionViewCell.self, forCellWithReuseIdentifier: TitleImageCollectionViewCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .gray
        contentView.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        collectionView.frame = contentView.bounds
    }

    func configure(with titles: [MovieModel]) {

        self.titles = titles

        DispatchQueue.main.async { [weak self] in

            self?.collectionView.reloadData()
        }
    }

    private func favoriteTitleAt(indexPath: IndexPath) {

        CoreDataManager.shared.favoriteTitleWith(model: titles[indexPath.row]) { result in

            switch result {
            case .success():

                NotificationCenter.default.post(name: NSNotification.Name("favoried"), object: nil)
            case .failure(let error):

                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleImageCollectionViewCell.identifier, for: indexPath)  as? TitleImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }

        cell.configure(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)

        let title = titles[indexPath.row]

        guard let titleName = title.original_title ?? title.original_name else { return }

        ApiCaller.shared.findMovieOnYoutube(with: titleName + " trailer") { [weak self] result in

            switch result {
            case .success(let videoELement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoELement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableCellDidTapCell(strongSelf, viewModel: viewModel)

            case .failure(let error):
                print(error)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // LongPress Menu

        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in

                let favoritedAction = UIAction(title: "Mark as Favorite", subtitle: self?.titles[indexPath.row].overview ?? "", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in

                    self?.favoriteTitleAt(indexPath : indexPath)
                }

                let title = self?.titles[indexPath.row].original_name ?? self?.titles[indexPath.row].original_title ?? ""

                return UIMenu(title: title, image: nil, identifier: nil, options: .displayInline, children: [favoritedAction])
        }

        return config
    }
}
