//
//  GuestSessionModel.swift
//  Movie App
//
//  Created by user on 12.12.2022.
//

import Foundation

struct GuestSessionModel: Codable {
    
    var success: Bool
    var guest_session_id: String
    var expires_at: String
}
