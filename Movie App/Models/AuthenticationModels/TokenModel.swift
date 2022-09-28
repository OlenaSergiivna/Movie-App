//
//  TokenModel.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import Foundation

struct Token: Codable {
    var success: Bool
    var expires_at: String
    var request_token: String
}
