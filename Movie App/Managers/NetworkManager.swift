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
    
    func requestAuthentication(username: String, password: String, completion: @escaping((String, Int, Int, Int) -> Void)) {
        
        // MARK: - First: Request token
        
        let requestTokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(Globals.apiKey)"
        let tokenRequest = AF.request(requestTokenUrl, method: .get)
        
        tokenRequest.responseDecodable(of: Token.self) { response in
            
            do {
                let data = try response.result.get()
                
                guard let responseRequest = response.response?.statusCode else { return }
                
                validateAuthentication(username: username, password: password, token: data.request_token) { responseValidate in
                    
                    createSession(token: data.request_token) { id, responseSession in
                        
                        completion(id, responseRequest, responseValidate, responseSession)
                    }
                }
                
            } catch {
                print("Request: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    // MARK: - Second: Validate token - PRIVATE
    
    private func validateAuthentication(username: String, password: String, token: String, completion: @escaping(Int) -> ()) {
        
        let validateTokenUrl = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(Globals.apiKey)&username=\(username)&password=\(password)&request_token=\(token)"
        
        let tokenValidation = AF.request(validateTokenUrl, method: .post)
        
        tokenValidation.responseDecodable(of: Token.self) { response in
            
            do {
                let _ = try response.result.get()
                if let responseValidate = response.response?.statusCode {
                    completion(responseValidate)
                }
            } catch {
                if let responseValidate = response.response?.statusCode {
                    print(responseValidate)
                    completion(responseValidate)
                }
                print("Validate: \(error.localizedDescription)")
            }
 
        }
    }
    
    
    // MARK: - Third: Create session id - PRIVATE
    
    private func createSession(token: String, completion: @escaping(String, Int) -> Void) {
        
        let sessionUrl = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(Globals.apiKey)&request_token=\(token)"
        let creatingSession = AF.request(sessionUrl, method: .get)
        
        creatingSession.responseDecodable(of: Session.self) { response in
            
            do {
                let data = try response.result.get()
                
                if let responseSession = response.response?.statusCode {
                    completion(data.session_id, responseSession)
                }
            } catch {
                
                print("Create: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Get user's details
    
    func getDetails(sessionId: String, completion: @escaping(_ id: Int, _ username: String, _ avatar: String) -> Void) {
        
        let getDetailsUrl = "https://api.themoviedb.org/3/account?api_key=\(Globals.apiKey)&session_id=\(sessionId)"
        let getDetailsSession = AF.request(getDetailsUrl, method: .get)
        
        getDetailsSession.responseDecodable(of: UserDetails.self) { response in
            
            do {
                let userDetails = try response.result.get()
                completion(userDetails.id, userDetails.username, userDetails.avatar.tmdb.avatar_path ?? "no avatar")
            } catch {
                print("user id: \(error.localizedDescription)")
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
        
        guard UserDefaults.standard.bool(forKey: "isguestsession") == false else {
            
            KingsfisherManager.shared.clearCasheKF()
            
            UserDefaultsManager.shared.deleteUsersDataFromUserDefaults()
            UserDefaults.standard.removeObject(forKey: "searchResults")

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
            
            return
        }
        
        guard let sessionID = UserDefaults.standard.string(forKey: "usersessionid") else { return }
        
        NetworkManager.shared.logOut(sessionId: sessionID) { result in
            guard result else { return }
            
            KingsfisherManager.shared.clearCasheKF()
            
            UserDefaultsManager.shared.deleteUsersDataFromUserDefaults()
            UserDefaults.standard.removeObject(forKey: "searchResults")
            
            // add clear realm and User Defaults
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
            
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "GetStartedViewController")
            //
            //            controller.present(destinationViewController, animated: true)
            //
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
