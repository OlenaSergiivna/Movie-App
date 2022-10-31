//
//  KingsfisherService.swift
//  Movie App
//
//  Created by user on 31.10.2022.
//

import Foundation
import Kingfisher

struct KingsfisherMemoryService {
    
    static let shared = KingsfisherMemoryService()
    
    let cashe = ImageCache.default
    
    
    func setCasheLimits() {
        cashe.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    }
    
    
    func clearCasheKF() {
        cashe.memoryStorage.removeAll()
    }
}
