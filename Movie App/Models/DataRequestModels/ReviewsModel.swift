//
//  ReviewsModel.swift
//  Movie App
//
//  Created by user on 08.12.2022.
//

import Foundation

struct ResultsReviews: Codable {
    let id, page: Int
    let results: [ReviewsModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct ReviewsModel: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt, url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}


struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}
