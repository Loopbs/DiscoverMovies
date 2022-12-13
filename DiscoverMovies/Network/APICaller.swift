//
//  APICaller.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import Foundation

struct Constants {

    static let apiKeyImdb = Configuration.apiKeyImdb
    static let apiKeyYoutube = Configuration.apiKeyYoutube
    static let baseImdbURL = Configuration.baseImdbURL
    static let baseYoutubeURL = Configuration.baseYoutubeURL
}

enum ApiError : Error {

    case failedTogetData
}

class ApiCaller {

    static let shared = ApiCaller()

    // Movie
    func getTrandingMovies(completion : @escaping (Result<[MovieModel],Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseImdbURL)/3/trending/movie/day?api_key=\(Constants.apiKeyImdb)") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in

            guard let data = data, error == nil else { return }

            do {

                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))
            } catch {

                completion(.failure(error))
            }

        }.resume()
    }

    func getUpcomingMovies(completion : @escaping (Result<[MovieModel],Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseImdbURL)/3/movie/upcoming?api_key=\(Constants.apiKeyImdb)&language=en-US&page=1") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_, error in
            guard let data = data , error == nil else { return }

            do {
                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getPopuler(completion : @escaping (Result<[MovieModel],Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseImdbURL)/3/movie/popular?api_key=\(Constants.apiKeyImdb)&language=en-US&page=1") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in

            guard let data = data, error == nil else { return }

            do {

                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))
            } catch {

                completion(.failure(error))
            }
        }.resume()
    }

    func getTopRated(completion : @escaping (Result<[MovieModel],Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseImdbURL)/3/movie/top_rated?api_key=\(Constants.apiKeyImdb)&language=en-US&page=1") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    func getTrandingTv(completion : @escaping (Result<[MovieModel],Error>)-> Void) {

        guard let url = URL(string: "\(Constants.baseImdbURL)/3/trending/tv/day?api_key=\(Constants.apiKeyImdb)") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: Search View

extension ApiCaller {

    func getDiscoveryMovies(completion : @escaping (Result<[MovieModel],Error>)-> Void) {

        guard let url = URL(string: "\(Constants.baseImdbURL)/3/discover/movie?api_key=\(Constants.apiKeyImdb)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in

            guard let data = data, error == nil else { return }

            do {

                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))            }
            catch {

                completion(.failure(error))
            }
        }.resume()
    }

    func search(with query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseImdbURL)/3/search/movie?api_key=\(Constants.apiKeyImdb)&query=\(query)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(ApiError.failedTogetData))
            }

        }
        task.resume()
    }
}

// MARK: Youtube

extension ApiCaller {

    func findMovieOnYoutube(with query: String, completion: @escaping (Result<YoutubeVideoModel, Error>) -> Void) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseYoutubeURL)q=\(query)&key=\(Constants.apiKeyYoutube)") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in

            guard let data = data, error == nil else { return }

            do {

                let results = try JSONDecoder().decode(YoutubeSearchModel.self, from: data)
                completion(.success(results.items[0]))
            } catch {

                completion(.failure(error))
                print(error.localizedDescription)
            }
        }.resume()
    }
}
