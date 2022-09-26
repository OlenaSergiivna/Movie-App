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
    var gravatar: Hash
    var tmdb: AvatarPath
}


struct Hash: Codable {
    var hash: String
}


struct AvatarPath: Codable {
    var avatar_path: String
}
