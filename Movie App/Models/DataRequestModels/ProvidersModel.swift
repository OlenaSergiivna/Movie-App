//
//  ProvidersModel.swift
//  Movie App
//
//  Created by user on 06.12.2022.
//

import Foundation

struct ResultsProviders: Codable {
    
    let results: [ProvidersModel]
}


struct ProvidersModel: Codable {
    
    let displayPriorities: [String: Int]
    let displayPriority: Int
    let logoPath, providerName: String
    let providerID: Int

    enum CodingKeys: String, CodingKey {
        case displayPriorities = "display_priorities"
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerName = "provider_name"
        case providerID = "provider_id"
    }
}
