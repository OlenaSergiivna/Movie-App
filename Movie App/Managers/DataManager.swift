//
//  DataManager.swift
//  Movie App
//
//  Created by user on 02.10.2022.
//

import Foundation

struct DataManager {
    
    static let shared = DataManager()
    
    private let apiKey = "b718f4e2921daaf000e347114cf44187"
    
    func fetchByGenre(genre: Int, page: Int, completion: @escaping ([Movie]) -> Void) {
        
        let genreId = Globals.genres[genre].id
        
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&with_genres=\(genreId)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error while fetching: \(error.localizedDescription)")
            }
            guard let jsonData = data else {
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(Results.self, from: jsonData)
                completion(data.results)
            } catch {
                print(String(describing: error))
            }
        }
        dataTask.resume()
    }
}

