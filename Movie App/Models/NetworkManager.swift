//
//  NetworkManager.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    func requestAutentification() {
        
        let apiKey = "b718f4e2921daaf000e347114cf44187"
        
        // MARK: - First: Request token
        
        let requestTokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
        let tokenRequest = AF.request(requestTokenUrl, method: .get)
        
        tokenRequest.responseDecodable(of: Token.self) { response in
            
            do {
                let data = try response.result.get()
                print(data)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        
    }
}
