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
    
    
    // MARK: - Main autentication request: Request token + Validate token + Create session
    
    func requestAuthentication(username: String, password: String, completion: @escaping((String) -> Void)) {
        
        // MARK: - First: Request token
        
        let requestTokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
        let tokenRequest = AF.request(requestTokenUrl, method: .get)
        
        tokenRequest.responseDecodable(of: Token.self) { response in
            
            do {
                let token = try response.result.get().request_token
                
                validateAuthentication(username: username, password: password, token: token)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    createSession(token: token) { id in
                        completion(id)
                    }
                }
                
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
                let _ = try response.result.get()
                
            } catch {
                print("Validate: \(error.localizedDescription)")
            }
        }
        
    }
    
    
    // MARK: - Third: Create session id
    
    func createSession(token: String, completion: @escaping(String) -> Void) {
        
        let sessionUrl = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)&request_token=\(token)"
        let creatingSession = AF.request(sessionUrl, method: .get)
        
        creatingSession.responseDecodable(of: Session.self) { response in
            
            do {
                let sessionId = try response.result.get().session_id
                completion(sessionId)
            } catch {
                print("Create: \(error.localizedDescription)")
            }
        }
    }
    
    func getDetails(sessionId: String) {
        
       let getDetailsUrl = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionId)"
        let getDetailsSession = AF.request(getDetailsUrl, method: .get)
        
        getDetailsSession.responseDecodable(of: , completionHandler: <#T##(DataResponse<Decodable, AFError>) -> Void#>)
    }
}
