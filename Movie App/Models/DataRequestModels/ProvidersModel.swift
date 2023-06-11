//
//  ProvidersModel.swift
//  Movie App
//
//  Created by user on 06.12.2022.
//

import Foundation

struct ResultsProviders: Codable {
    let id: Int
    let results: USProvidersModel?
}


struct USProvidersModel: Codable {
    let US: Providers?
}


struct Providers: Codable {
    let link: String
    let rent: [ProviderDetails]?
    let buy: [ProviderDetails]?
    let flatrate: [ProviderDetails]?
}


struct ProviderDetails: Codable {
    let displayPriority: Int
    let logoPath: String
    let providerID: Int
    let providerName: String
    
    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
    }
}
