//
//  MovieGenresModels.swift
//  Movie App
//
//  Created by user on 28.09.2022.
//

import Foundation

struct Genres: Codable {
    let genres: [Genre]
}


struct Genre: Codable {
    let id: Int
    let name: String
}
