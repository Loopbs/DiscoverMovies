//
//  FavoritesViewController.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    private var titles: [TitleItem] = [TitleItem]()

    private let favoritedTable: UITableView = {

        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)

        return table
    }()

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(favoritedTable)
        title = "Favories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        favoritedTable.delegate = self
        favoritedTable.dataSource = self
        fetchLocalStorageForFavorite()
        CoreDataManager.shared.getCoreDataDBPath()

        NotificationCenter.default.addObserver(forName: NSNotification.Name("favoried"), object: nil, queue: nil) { [weak self] _ in

            self?.fetchLocalStorageForFavorite()
        }
    }

    private func fetchLocalStorageForFavorite() {

        CoreDataManager.shared.fetchTitlesFromDataBase { [weak self] result in

            switch result {
            case .success(let titles):

                DispatchQueue.main.async { [weak self] in

                    self?.titles = titles
                    self?.favoritedTable.reloadData()
                }
            case .failure(let error):

                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        favoritedTable.frame = view.bounds
    }
}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell()}

        cell.configure(with: TitleViewModel(titleName:  titles[indexPath.row].original_name ?? titles[indexPath.row].originial_title ?? ""  , posterURL: titles[indexPath.row].poster_path ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
        case .delete:

            CoreDataManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]

        guard let titleName = title.originial_title ?? title.original_name else { return }

        ApiCaller.shared.findMovieOnYoutube(with: titleName) { [weak self] result in

            switch result {
            case .success(let videoElement):

                DispatchQueue.main.async { [weak self] in

                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))

                    self?.navigationController?.pushViewController(vc, animated: true) // herhangi bir satira tikladiginda detay sayfasina gidecel
                }
            case .failure(let error):

                print(error.localizedDescription)
            }
        }
    }
}
