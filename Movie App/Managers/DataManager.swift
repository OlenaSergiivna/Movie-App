//
//  DataManager.swift
//  Movie App
//
//  Created by user on 02.10.2022.
//

import Foundation
import Alamofire

struct DataManager {
    
    static let shared = DataManager()
    
    private let apiKey = "b718f4e2921daaf000e347114cf44187"
    
    
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
    
    
    // MARK: - Request movie by specific genre/genres
    
    func requestMoviesByGenre(genre: String, page: Int, completion: @escaping([MovieModel]) -> Void) {
        
        guard let genreId = Globals.genres.first(where: { $0.name == genre})?.id else { return }
        
        let movieByGenreURL = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&with_genres=\(genreId)&page=\(page)"
        
        let movieByGenreRequest = AF.request(movieByGenreURL, method: .get)
        
        movieByGenreRequest.responseDecodable(of: ResultsMovie.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Request movies from Favorites list
    
    enum MediaType {
        case movie
        case tv
    }
    
    func requestFavorites(completion: @escaping ([MovieModel]) -> Void) {
        
        let favouritesRequest = AF.request("https://api.themoviedb.org/3/account/\(Globals.userId)/favorite/movies?api_key=\(apiKey)&session_id=\(Globals.sessionId)&language=en-US&sort_by=created_at.asc&page=1", method: .get)
        
        favouritesRequest.responseDecodable(of: ResultsMovie.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Delete movie from Favorites list
    
    func deleteFromFavorites(id: Int, type: String, completion: @escaping(Int) -> Void ) {
        
        let parameters: [String : Any] = [
            "media_type" : type,
            "media_id" : id,
            "favorite" : false
        ]
        
        let deleteURL = "https://api.themoviedb.org/3/account/\(Globals.userId)/favorite?api_key=\(apiKey)&session_id=\(Globals.sessionId)"
        
        
        let deleteFromFavoritesRequest = AF.request(deleteURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        deleteFromFavoritesRequest.responseDecodable(of: Removed.self) { response in
            do {
                let result = try response.result.get()
                print(result)
                if let response = response.response?.statusCode {
                    completion(response)
                }
                
            } catch {
                print("removed: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Search TV Shows by text request
    
    func searchTV(with text: String, page: Int, adult: Bool = false, completion: @escaping([TVModel]) -> Void) {
        
        let searchRequest = AF.request("https://api.themoviedb.org/3/search/tv?api_key=\(apiKey)&language=en-US&query=\(text)&page=\(page)&include_adult=\(adult)", method: .get)
       
        searchRequest.responseDecodable(of: ResultsTV.self) { response in
            print("tv url: \(searchRequest)")
            do {
                let data = try response.result.get().results
                print("tv show decoded")
                completion(data)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    // MARK: - Search movies by text request
    
    func searchMovie(with text: String, page: Int, adult: Bool = false, completion: @escaping([MovieModel]) -> Void) {
        
        let searchRequest = AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(text)&page=\(page)&include_adult=\(adult)", method: .get)
       
        searchRequest.responseDecodable(of: ResultsMovie.self) { response in
            print("movie url: \(searchRequest)")
            
            do {
                let data = try response.result.get().results
                print("movie decoded")
                completion(data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

