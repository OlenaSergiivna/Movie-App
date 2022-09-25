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
    
    private let apiKey = "b718f4e2921daaf000e347114cf44187"
    
    // MARK: - First: Request token
    
    func requestAuthentication(completion: @escaping(String) -> Void) {
        
        let requestTokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
        let tokenRequest = AF.request(requestTokenUrl, method: .get)
        
        tokenRequest.responseDecodable(of: Token.self) { response in
            
            do {
                let data = try response.result.get().request_token
                print(data)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Second: Validate token
    
    func validateAuthentication(username: String, password: String, token: String) {
        
        let validateTokenUrl = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)&username=\(username)&password=\(password)&request_token=\(token)"
        
        let tokenValidation = AF.request(validateTokenUrl, method: .post)
        
        tokenValidation.responseDecodable(of: Token.self) { response in
            
            do {
                let data = try response.result.get()
                print(data)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func createSession(token: String) {
        
     let sessionUrl = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)&request_token=\(token)"
        let creatingSession = AF.request(sessionUrl, method: .post)
        
        creatingSession.responseDecodable(of: Session.self) { response in
            
            do {
                let data = try response.result.get().session_id
                print(data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
