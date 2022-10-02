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
    
    func requestAuthentication(username: String, password: String, completion: @escaping((String, Int, Int, Int) -> Void)) {
        
        // MARK: - First: Request token
        
        let requestTokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
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
        
        let validateTokenUrl = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)&username=\(username)&password=\(password)&request_token=\(token)"
        
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
        
        let sessionUrl = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)&request_token=\(token)"
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
    
    func getDetails(sessionId: String, completion: @escaping(Int) -> Void) {
        
        let getDetailsUrl = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionId)"
        let getDetailsSession = AF.request(getDetailsUrl, method: .get)
        
        getDetailsSession.responseDecodable(of: UserDetails.self) { response in
            
            do {
                let userId = try response.result.get().id
                completion(userId)
            } catch {
                print("user id: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Log out (delete current session)
    
    func logOut(sessionId: String, completion: @escaping(Bool) -> Void) {
        
        let logOutUrl = "https://api.themoviedb.org/3/authentication/session?api_key=\(apiKey)&session_id=\(sessionId)"
        let logOutSession = AF.request(logOutUrl, method: .delete)
        
        logOutSession.responseDecodable(of: LogOut.self) { response in
            do {
                let result = try response.result.get().success
                print("Log out: \(result)")
                completion(result)
            } catch {
                print("Log out: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Request movie genres
    
    
    func requestMovieGenres(completion: @escaping([Genre]) -> Void) {
        
        let request = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)", method: .get)
        
        request.responseDecodable(of: Genres.self) { response in
            do {
                let data = try response.result.get().genres
                completion(data)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    // MARK: - Request tv shows genres
    
    func requestTVGenres(completion: @escaping([Genre]) -> Void) {
        
        let request = AF.request("https://api.themoviedb.org/3/genre/tv/list?api_key=\(apiKey)&language=en-US", method: .get)
        
        request.responseDecodable(of: Genres.self) { response in
            do {
                let data = try response.result.get().genres
                completion(data)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func requestMoviesByGenre(genre: String, page: Int, completion: @escaping([Movie]) -> Void) {
        
        let genreId = Globals.genres.first(where: { $0.name == genre})?.id
        print("Id: \(genreId!)")
            let movieByGenreURL = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&with_genres=\(genreId!)&page=\(page)"
            let movieByGenreRequest = AF.request(movieByGenreURL, method: .get)
            print(movieByGenreURL)
            movieByGenreRequest.responseDecodable(of: Results.self) { response in
                do {
                    let data = try response.result.get().results
                    completion(data)
                } catch {
                    print(error.localizedDescription)
            }
        }
        
       
    }
    
}