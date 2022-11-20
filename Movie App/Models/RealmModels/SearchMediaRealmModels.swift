//
//  SearchMediaRealmModels.swift
//  Movie App
//
//  Created by user on 18.11.2022.
//

import Foundation

 enum Media: Codable, Hashable {

    case movie(MovieModel)
    case tvShow(TVModel)
    
}
