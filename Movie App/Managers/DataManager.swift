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

