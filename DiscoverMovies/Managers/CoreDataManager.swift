//
//  CoreDataManager.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {

    enum Constant {

        static let persistentName = "DiscoverMovies"
    }

    enum DatabaseError: Error {

        case failedToSave
        case failedFetchData
        case failedToDeleteData
    }

    static let shared = CoreDataManager()

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: Constant.persistentName)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {

        let context = persistentContainer.viewContext

        if context.hasChanges {

            do {

                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func favoriteTitleWith(model: MovieModel, completion: @escaping (Result<Void, Error>) -> Void) {

        let context =  persistentContainer.viewContext
        let item = TitleItem(context: context)

        item.original_name = model.original_name
        item.originial_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_avarage = model.vote_average

        do {

            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSave))
        }
    }

    func fetchTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>)-> Void) {

        let context = persistentContainer.viewContext
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()

        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedFetchData))
        }
    }

    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {

        let context = persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }

    func getCoreDataDBPath() {

        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Core Data DB Path :: \(path ?? "Not found")")
    }
}
