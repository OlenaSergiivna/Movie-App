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
    
    func requestMovieGenres(completion: @escaping([Genre], Int) -> Void) {
        
        let request = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(Globals.apiKey)", method: .get)
        
        request.responseDecodable(of: Genres.self) { response in
            do {
                let data = try response.result.get().genres
                guard let statusCode = response.response?.statusCode else {
                   return
                }
                completion(data, statusCode)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    // MARK: - Request tv shows genres
    
    func requestTVGenres(completion: @escaping([Genre], Int) -> Void) {
        
        let request = AF.request("https://api.themoviedb.org/3/genre/tv/list?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        request.responseDecodable(of: Genres.self) { response in
            do {
                let data = try response.result.get().genres
                guard let statusCode = response.response?.statusCode else {
                   return
                }
                completion(data, statusCode)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    // MARK: - Request movies by specific genre/genres
    // models?
    func requestMoviesByGenre(genre: String, page: Int, completion: @escaping([MovieModel]) -> Void) {
        
        guard let genreId = Globals.movieGenres.first(where: { $0.name == genre})?.id else { return }
        
        let movieByGenreURL = "https://api.themoviedb.org/3/discover/movie?api_key=\(Globals.apiKey)&with_genres=\(genreId)&page=\(page)"
       
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
    
    
    
    // MARK: - Request tv shows by specific genre/genres
    // models?
    func requestTVByGenre(genre: String, page: Int, completion: @escaping([TVModel]) -> Void) {
        
        guard let genreId = Globals.tvGenres.first(where: { $0.name == genre})?.id else { return }
        
        let tvByGenreURL = "https://api.themoviedb.org/3/discover/tv?api_key=\(Globals.apiKey)&with_genres=\(genreId)&page=\(page)"
        
        let tvByGenreRequest = AF.request(tvByGenreURL, method: .get)
        
        tvByGenreRequest.responseDecodable(of: ResultsTV.self) { response in
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
    
    
    func requestFavoriteMovies(completion: @escaping (_ success: Bool, _ favorites: [MovieModel]?, _ error: Error?, _ underlyingError: Error?) -> ()) -> Void {
        
        let urlMovie = "https://api.themoviedb.org/3/account/\(Globals.userId)/favorite/movies?api_key=\(Globals.apiKey)&session_id=\(Globals.sessionId)&language=en-US&sort_by=created_at.asc&page=1"
        //print(urlMovie)
        AF.request(urlMovie,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   requestModifier: { $0.timeoutInterval = 2 })
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ResultsMovie.self) { response in
            
            switch response.result {
            case .success:
                
                    do {
                        let data = try response.result.get().results
                        completion(true, data, nil, nil)
                    } catch {
                        
                        let error = response.error
                       
                        print("Decoding error: \(String(describing: error)). Status code: \(String(describing: response.response?.statusCode))")
                        completion(false, nil, error, error?.underlyingError)
                    }
                    

            case .failure(let error):
               
                print("Failure. Status code: \(String(describing: response.response?.statusCode ?? 0))")
                //Error description: \(error.localizedDescription)
                
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            print("Underlying error: Timed out error")
                        case .notConnectedToInternet:
                            print("Underlying error: Not connected")
                        default:
                            //Do something
                            print("Underlying error: Unmanaged error")
                        }
                    }
                }
                completion(false, nil, error, error.underlyingError)
            }
        }
    }
    
    
    
    func requestFavoriteTVShows(completion: @escaping (_ success: Bool, _ favorites: [TVModel]?, _ error: Error?, _ underlyingError: Error?) -> ()) -> Void {
        
        let urlTV = "https://api.themoviedb.org/3/account/\(Globals.userId)/favorite/tv?api_key=\(Globals.apiKey)&session_id=\(Globals.sessionId)&language=en-US&sort_by=created_at.asc&page=1"
        print(urlTV)
        
        AF.request(urlTV,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   requestModifier: { $0.timeoutInterval = 2 })
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ResultsTV.self) { response in
            
            switch response.result {
            case .success:
                
                    do {
                        let data = try response.result.get().results
                        completion(true, data, nil, nil)
                    } catch {
                        
                        let error = response.error
                       
                        print("Decoding error: \(String(describing: error)). Status code: \(String(describing: response.response?.statusCode))")
                        completion(false, nil, error, error?.underlyingError)
                    }
                    

            case .failure(let error):
               
                print("Failure. Status code: \(String(describing: response.response?.statusCode ?? 0))")
                //Error description: \(error.localizedDescription)
                
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            print("Underlying error: Timed out error")
                        case .notConnectedToInternet:
                            print("Underlying error: Not connected")
                        default:
                            //Do something
                            print("Underlying error: Unmanaged error")
                        }
                    }
                }
                completion(false, nil, error, error.underlyingError)
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
        
        let deleteURL = "https://api.themoviedb.org/3/account/\(Globals.userId)/favorite?api_key=\(Globals.apiKey)&session_id=\(Globals.sessionId)"
        print(deleteURL)
        
        let deleteFromFavoritesRequest = AF.request(deleteURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        deleteFromFavoritesRequest.responseDecodable(of: FavoritesResponse.self) { response in
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
    
    
    
    func addToFavorites(id: Int, type: String, completion: @escaping(Int) -> Void ) {
        
        let addURL = "https://api.themoviedb.org/3/account/\(Globals.userId)/favorite?api_key=\(Globals.apiKey)&session_id=\(Globals.sessionId)&media_id=\(id)&media_type=\(type)&favorite=true"
        
        
        let addToFavoritesRequest = AF.request(addURL, method: .post)
        
        addToFavoritesRequest.responseDecodable(of: FavoritesResponse.self) { response in
            do {
                let result = try response.result.get()
                print(result)
                if let response = response.response?.statusCode {
                    completion(response)
                }
                
            } catch {
                print("added: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    // MARK: - Search TV Shows by text request
    
    func searchTV(with text: String, page: Int, adult: Bool = false, completion: @escaping([TVModel]) -> Void) {
        
        let searchRequest = AF.request("https://api.themoviedb.org/3/search/tv?api_key=\(Globals.apiKey)&language=en-US&query=\(text)&page=\(page)&include_adult=\(adult)", method: .get)
        
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
        
        let searchRequest = AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(Globals.apiKey)&language=en-US&query=\(text)&page=\(page)&include_adult=\(adult)", method: .get)
        
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
    
    
    
    // MARK: - Request popular now media
    
    func requestTrendyMedia(completion: @escaping([TrendyMedia]) -> Void) {
        
        let trendyRequest = AF.request("https://api.themoviedb.org/3/trending/all/day?api_key=\(Globals.apiKey)&page=1", method: .get)
    
        trendyRequest.responseDecodable(of: Trends.self) { response in
        
            do {
                let data = try response.result.get().results
                completion(data)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    
    // MARK: - Request now playing movies
    
    func requestNowPlayingMovies(completion: @escaping([MovieModel]) -> Void) {
   
        let nowPlayingRequest = AF.request("https://api.themoviedb.org/3/movie/now_playing?api_key=\(Globals.apiKey)&language=en-US&page=1&region=US", method: .get)
   
        nowPlayingRequest.responseDecodable(of: NowPlayingResults.self) { response in
        print(response)
            do {
                let data = try response.result.get().results
                completion(data)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
}

