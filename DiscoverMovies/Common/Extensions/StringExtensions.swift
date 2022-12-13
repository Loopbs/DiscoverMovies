//
//  StringExtensions.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import Foundation

extension String {

    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
}
