//
//  UserDetails.swift
//  Movie App
//
//  Created by user on 26.09.2022.
//

import Foundation

struct UserDetails: Codable {
    var avatar: Avatar
    var id: Int
    var iso_639_1: String
    var iso_3166_1: String
    var name: String
    var include_adult: Bool
    var username: String
}


struct Avatar: Codable {
    var gravatar: Gravatar
    var tmdb: TMDB
}


struct Gravatar: Codable {
    var hash: String
}


struct TMDB: Codable {
    var avatar_path: JSONNull
}


class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        //
    }
    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
