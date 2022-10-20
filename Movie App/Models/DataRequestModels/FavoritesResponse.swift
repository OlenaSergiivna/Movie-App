//
//  RemovedResponseModel.swift
//  Movie App
//
//  Created by user on 06.10.2022.
//

import Foundation

struct FavoritesResponse: Codable {
    var success: Bool
    var status_code: Int
    var status_message: String
}
