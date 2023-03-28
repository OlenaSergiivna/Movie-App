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
    
    private init() {}
    
    func requestMovieGenres(completion: @escaping([Genre], Int) -> Void) {
        
        let request = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(Globals.apiKey)", method: .get)
        
        request.responseDecodable(of: Genres.self) { response in
            do {
                let data = try response.result.get().genres
                guard let statusCode = response.response?.statusCode else { return }
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
                guard let statusCode = response.response?.statusCode else { return }
                completion(data, statusCode)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    // MARK: - Request movies by specific genre/genres
    // models?
    func requestMoviesByGenre(genre: String, page: Int, completion: @escaping([MovieModel], Int) -> Void) {
        
        guard let genreId = Globals.movieGenres.first(where: { $0.name == genre})?.id else { return }
        
        let movieByGenreURL = "https://api.themoviedb.org/3/discover/movie?api_key=\(Globals.apiKey)&with_genres=\(genreId)&page=\(page)"
        
        let movieByGenreRequest = AF.request(movieByGenreURL, method: .get)
        
        movieByGenreRequest.responseDecodable(of: ResultsMovie.self) { response in
            do {
                let data = try response.result.get()
                completion(data.movies, data.totalPages)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: - Request tv shows by specific genre/genres
    // models?
    func requestTVByGenre(genre: String, page: Int, completion: @escaping([TVModel], Int) -> Void) {
        
        guard let genreId = Globals.tvGenres.first(where: { $0.name == genre})?.id else { return }
        
        let tvByGenreURL = "https://api.themoviedb.org/3/discover/tv?api_key=\(Globals.apiKey)&with_genres=\(genreId)&page=\(page)"
        
        let tvByGenreRequest = AF.request(tvByGenreURL, method: .get)
        
        tvByGenreRequest.responseDecodable(of: ResultsTV.self) { response in
            do {
                let data = try response.result.get()
                completion(data.tvShows, data.totalPages)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Request movies from Favorites list
    
    func requestFavoriteMovies(page: Int = 1, completion: @escaping (_ success: Bool, _ totalPages: Int, _ favorites: [MovieModel]?,  _ error: Error?, _ underlyingError: Error?) -> ()) -> Void {
        
        guard let sessionID = UserDefaults.standard.string(forKey: "usersessionid") else { return }
        
        guard let userID = UserDefaults.standard.string(forKey: "userid") else { return }
        
        let urlMovie = "https://api.themoviedb.org/3/account/\(userID)/favorite/movies?api_key=\(Globals.apiKey)&session_id=\(sessionID)&language=en-US&sort_by=created_at.asc&page=\(page)"
        
        AF.request(urlMovie,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   requestModifier: { $0.timeoutInterval = 30 })
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ResultsMovie.self) { response in
            
            switch response.result {
            case .success:
                
                do {
                    let data = try response.result.get()
                    let totalPages = data.totalPages
                    completion(true, totalPages, data.movies, nil, nil)
                } catch {
                    
                    let error = response.error
                    
                    print("Decoding error: \(String(describing: error)). Status code: \(String(describing: response.response?.statusCode))")
                    completion(false, 0, nil, error, error?.underlyingError)
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
                completion(false, 0, nil, error, error.underlyingError)
            }
        }
    }
    
    
    
    func requestFavoriteTVShows(page: Int = 1, completion: @escaping (_ success: Bool, _ totalPages: Int, _ favorites: [TVModel]?, _ error: Error?, _ underlyingError: Error?) -> ()) -> Void {
        
        guard let sessionID = UserDefaults.standard.string(forKey: "usersessionid") else { return }
        
        guard let userID = UserDefaults.standard.string(forKey: "userid") else { return }
        
        let urlTV = "https://api.themoviedb.org/3/account/\(userID)/favorite/tv?api_key=\(Globals.apiKey)&session_id=\(sessionID)&language=en-US&sort_by=created_at.asc&page=\(page)"
        
        AF.request(urlTV,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   requestModifier: { $0.timeoutInterval = 30 })
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ResultsTV.self) { response in
            
            switch response.result {
            case .success:
                
                do {
                    let data = try response.result.get()
                    let totalPages = data.totalPages
                    completion(true, totalPages, data.tvShows, nil, nil)
                } catch {
                    
                    let error = response.error
                    
                    print("Decoding error: \(String(describing: error)). Status code: \(String(describing: response.response?.statusCode))")
                    completion(false, 0, nil, error, error?.underlyingError)
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
                completion(false, 0, nil, error, error.underlyingError)
            }
        }
    }
    
    
    
    // MARK: - Delete movie from Favorites list
    
    func deleteFromFavorites(id: Int, type: String, completion: @escaping(Bool) -> Void ) {
        
        let parameters: [String : Any] = [
            "media_type" : type,
            "media_id" : id,
            "favorite" : false
        ]
        
        guard let sessionID = UserDefaults.standard.string(forKey: "usersessionid") else { return }
        
        guard let userID = UserDefaults.standard.string(forKey: "userid") else { return }
        
        let deleteURL = "https://api.themoviedb.org/3/account/\(userID)/favorite?api_key=\(Globals.apiKey)&session_id=\(sessionID)"
        
        let deleteFromFavoritesRequest = AF.request(deleteURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        deleteFromFavoritesRequest.responseDecodable(of: FavoritesResponse.self) { response in
            do {
                let result = try response.result.get()
                completion(result.success)
                
            } catch {
                print("Delete from favorites: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func addToFavorites(id: Int, type: String, completion: @escaping(Bool) -> Void ) {
        
        guard let sessionID = UserDefaults.standard.string(forKey: "usersessionid") else { return }
        
        guard let userID = UserDefaults.standard.string(forKey: "userid") else { return }
        
        let addURL = "https://api.themoviedb.org/3/account/\(userID)/favorite?api_key=\(Globals.apiKey)&session_id=\(sessionID)&media_id=\(id)&media_type=\(type)&favorite=true"
        
        
        let addToFavoritesRequest = AF.request(addURL, method: .post)
        
        addToFavoritesRequest.responseDecodable(of: FavoritesResponse.self) { response in
            do {
                let data = try response.result.get()
                completion(data.success)
            
            } catch {
                print("added: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    // MARK: - Search TV Shows by text request
    
    func searchTV(with text: String, page: Int, adult: Bool = false, completion: @escaping(Result<ResultsTV, Error>) -> Void) {
        
        let searchRequest = AF.request("https://api.themoviedb.org/3/search/tv?api_key=\(Globals.apiKey)&language=en-US&query=\(text)&page=\(page)&include_adult=\(adult)", method: .get)
        
        searchRequest.responseDecodable(of: ResultsTV.self) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Search movies by text request
    
    func searchMovie(with text: String, page: Int, adult: Bool = false, completion: @escaping(Result<ResultsMovie, Error>) -> Void) {
        
        let searchRequest = AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(Globals.apiKey)&language=en-US&query=\(text)&page=\(page)&include_adult=\(adult)", method: .get)
        
        searchRequest.responseDecodable(of: ResultsMovie.self) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // MARK: - Request popular now media
    
    func requestTrendyMedia(page: Int = 1, completion: @escaping([TrendyMedia], Int) -> Void) {
        
        let trendyRequest = AF.request("https://api.themoviedb.org/3/trending/all/day?api_key=\(Globals.apiKey)&page=\(page)", method: .get)
        
        trendyRequest.responseDecodable(of: Trends.self) { response in
            
            do {
                let data = try response.result.get()
                completion(data.results, data.totalPages)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    
    // MARK: - Request now playing movies
    
    func requestNowPlayingMovies(page: Int = 1, completion: @escaping([MovieModel], Int) -> Void) {
        
        let nowPlayingRequest = AF.request("https://api.themoviedb.org/3/movie/now_playing?api_key=\(Globals.apiKey)&language=en-US&page=\(page)&region=US", method: .get)
        
        nowPlayingRequest.responseDecodable(of: NowPlayingResults.self) { response in
            
            do {
                let data = try response.result.get()
                completion(data.results, data.totalPages)
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func getMediaTrailer(id: Int, mediaType: String, completion: @escaping (Result<[TrailerModel], Error>) -> Void) {
        
        let trailerRequest = AF.request("https://api.themoviedb.org/3/\(mediaType)/\(id)/videos?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        trailerRequest.responseDecodable(of: ResultsTrailers.self ) { response in
            
            switch response.result {
                
            case .success(let results):
                completion(.success(results.results))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getMediaCast(mediaType: String, mediaId: Int, completion: @escaping (Result<[CastModel], Error>) -> Void) {
        
        let castRequest = AF.request("https://api.themoviedb.org/3/\(mediaType)/\(mediaId)/credits?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        castRequest.responseDecodable(of: ResultsCast.self ) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getMovieDetails(mediaId: Int, completion: @escaping(Result<MovieDetailedModel, Error>) -> Void) {
        
        let movieDetailsRequest = AF.request("https://api.themoviedb.org/3/movie/\(mediaId)?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        movieDetailsRequest.responseDecodable(of: MovieDetailedModel.self ) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getTVShowDetails(mediaId: Int, completion: @escaping(Result<TVShowDetailedModel, Error>) -> Void) {
        
        let movieDetailsRequest = AF.request("https://api.themoviedb.org/3/tv/\(mediaId)?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        movieDetailsRequest.responseDecodable(of: TVShowDetailedModel.self ) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getSimilarMovies(movieId: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let similarMoviesRequest = AF.request("https://api.themoviedb.org/3/movie/\(movieId)/recommendations?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        similarMoviesRequest.responseDecodable(of: ResultsMovie.self ) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data.movies))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getSimilarTVShows(mediaId: Int, completion: @escaping (Result<[TVModel], Error>) -> Void) {
        
        let similarTVShowsRequest = AF.request("https://api.themoviedb.org/3/tv/\(mediaId)/recommendations?api_key=\(Globals.apiKey)&language=en-US", method: .get)
        
        similarTVShowsRequest.responseDecodable(of: ResultsTV.self ) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data.tvShows))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getProviders(mediaType: String, mediaID: Int, completion: @escaping(Result<Providers, Error>) -> Void) {
        
        let getProvidersRequest = AF.request("https://api.themoviedb.org/3/\(mediaType)/\(mediaID)/watch/providers?api_key=\(Globals.apiKey)", method: .get)
        
        getProvidersRequest.responseDecodable(of: ResultsProviders.self ) { response in
            
            switch response.result {
                
            case .success(let data):
                guard let results = data.results?.US else { return }
                completion(.success(results))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func cancelAllTasks() {
        
        Alamofire.Session.default.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        })
    }
}
