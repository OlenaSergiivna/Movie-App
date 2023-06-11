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
    
    private init() {}
    
    // MARK: - Main autentication request: Request token + Validate token + Create session
    
    func requestAuthentication(username: String, password: String, completion: @escaping(Result<String,Error>) -> Void) {
        
        // MARK: - First: Request token
        
        let requestTokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(Globals.apiKey)"
        let tokenRequest = AF.request(requestTokenUrl, method: .get)
        
        tokenRequest.responseDecodable(of: Token.self) { response in
            
            switch response.result {
                
            case .success(let token):
                print("Success while requesting token: \(token.request_token)")
                
                validateAuthentication(username: username, password: password, token: token.request_token) { result in
                    
                    switch result {
                        
                    case .success(let success):
                        print("Success while validating authentication: \(success)")
                        
                        createSession(token: token.request_token) { result in
                            
                            switch result {
                                
                            case .success(let session):
                                print("Success while creating session: \(success)")
                                completion(.success(session))
                                
                            case .failure(let error):
                                print("Error while creating session: \(error.localizedDescription)")
                            }
                        }
                        
                    case .failure(let error):
                        print("Error while validating authentication: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // MARK: - Second: Validate token - PRIVATE
    
    private func validateAuthentication(username: String, password: String, token: String, completion: @escaping(Result<Bool, Error>) -> ()) {
        
        let validateTokenUrl = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(Globals.apiKey)&username=\(username)&password=\(password)&request_token=\(token)"
        
        let tokenValidation = AF.request(validateTokenUrl, method: .post)
        
        tokenValidation.responseDecodable(of: Token.self) { response in
            
            switch response.result {
                
            case .success(let isSuccess):
                completion(.success(isSuccess.success))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Third: Create session id - PRIVATE
    
    private func createSession(token: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        let sessionUrl = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(Globals.apiKey)&request_token=\(token)"
        let creatingSession = AF.request(sessionUrl, method: .get)
        
        creatingSession.responseDecodable(of: Session.self) { response in
            
            switch response.result {
                
            case .success(let session):
                completion(.success(session.session_id))
                
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Get user's details
    
    func getUserDetails(sessionId: String, completion: @escaping(Result<UserDetails, Error>) -> Void) {
        
        let getDetailsUrl = "https://api.themoviedb.org/3/account?api_key=\(Globals.apiKey)&session_id=\(sessionId)"
        let getDetailsSession = AF.request(getDetailsUrl, method: .get)
        
        getDetailsSession.responseDecodable(of: UserDetails.self) { response in
            
            switch response.result {
                
            case .success(let userDetails):
                completion(.success(userDetails))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // MARK: - Log out (delete current session)
    
    private func logOut(sessionId: String, completion: @escaping(Bool) -> Void) {
        
        let logOutUrl = "https://api.themoviedb.org/3/authentication/session?api_key=\(Globals.apiKey)&session_id=\(sessionId)"
        let logOutSession = AF.request(logOutUrl, method: .delete)
        
        logOutSession.responseDecodable(of: LogOut.self) { response in
            do {
                let result = try response.result.get().success
                print("Logged out: \(result)")
                completion(result)
            } catch {
                print("Log out: \(error.localizedDescription)")
            }
        }
    }
    
    
    func logOutAndGetBackToLoginView(_ controller: UIViewController) {
        
        guard UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.getKeyFor(.isGuestSession)) == false else {
            
            KingsfisherManager.shared.clearCasheKF()
            
            UserDefaultsManager.shared.deleteUsersDataFromUserDefaults()
            UserDefaults.standard.removeObject(forKey: UserDefaultsManager.shared.getKeyFor(.searchResults))
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "GetStartedViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC)
            
            return
        }
        
        guard let sessionID = UserDefaults.standard.string(forKey: UserDefaultsManager.shared.getKeyFor(.sessionID)) else { return }
        
        NetworkManager.shared.logOut(sessionId: sessionID) { result in
            guard result else { return }
            
            KingsfisherManager.shared.clearCasheKF()
            
            UserDefaultsManager.shared.deleteUsersDataFromUserDefaults()
            UserDefaults.standard.removeObject(forKey: UserDefaultsManager.shared.getKeyFor(.searchResults))
            
            RealmManager.shared.deleteAll()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "GetStartedViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC)
        }
    }
    
    
    func createGuestSession(completion: @escaping(GuestSessionModel) -> Void) {
        
        let guestSessionUrl = "https://api.themoviedb.org/3/authentication/guest_session/new?api_key=\(Globals.apiKey)"
        let guestSession = AF.request(guestSessionUrl, method: .get)
        
        guestSession.responseDecodable(of: GuestSessionModel.self) { response in
            do {
                let result = try response.result.get()
                print("Logged in as a guest: \(result)")
                completion(result)
            } catch {
                print("Logged in as a guest: \(error.localizedDescription)")
            }
        }
    }
}
