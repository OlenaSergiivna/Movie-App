//
//  DetailsScreenViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher

// add popup message when media has been added to favorites list or deleted from it

class DetailsScreenViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaName: UILabel!
    
    @IBOutlet weak var mediaRating: UILabel!
    
    @IBOutlet weak var mediaGenres: UILabel!
    
    @IBOutlet weak var mediaOverview: UILabel!
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    var media: [Any] = []
    
    var mediaId: Int = 0
    
    var mediaType: String = ""
    
//    var mediaType: String = "" {
//        didSet {
//
//            if mediaType == "movie" {
//
//                DataManager.shared.requestFavoriteMovies { [weak self] success, favorites, _, _ in
//                    guard let self else { return }
//
//                    if let favorites = favorites {
//
//                        self.favoriteMedia = favorites
//                    }
//                }
//
//            } else if mediaType == "tv" {
//
//                DataManager.shared.requestFavoriteTVShows { [weak self] success, favorites, _, _ in
//                    guard let self else { return }
//
//                    if let favorites = favorites {
//
//                        self.favoriteMedia = favorites
//                    }
//                 }
//
//            }
//        }
//    }
//
//
//
//    var favoriteMedia: [Any] = [] {
//        didSet {
//
//            if favoriteMedia is [MovieModel] {
//                let favoriteMedia = favoriteMedia as! [MovieModel]
//
//                if favoriteMedia.contains(where: { $0.id == mediaId }) {
//                    isFavorite = true
//
//                } else {
//                    isFavorite = false
//                }
//
//            } else if favoriteMedia is [TVModel] {
//                let favoriteMedia = favoriteMedia as! [TVModel]
//
//                if favoriteMedia.contains(where: { $0.id == mediaId }) {
//                    isFavorite = true
//
//                } else {
//                    isFavorite = false
//                }
//            }
//
//        }
//    }
//
//
//
    var isFavorite: Bool = false {
        didSet {
            if isFavorite == true {

                favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoritesButton.tintColor = .systemRed
            } else {

                favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoritesButton.tintColor = .systemRed
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Configuring DetailsScreen with data depends on tapped cell type
    
    func configure<T>(with cell: T) {
        
        if cell is MovieModel {
            
            let cell = cell as! MovieModel
            
            mediaType = "movie"
            media.append(cell)
            mediaId = cell.id
            
            configureFavoriteButton(cell: cell)
            
            mediaName.text = cell.title
            mediaRating.text = "★ \(round((cell.voteAverage * 100))/100)"
            
            mediaOverview.text = cell.overview
            
            // MARK: Configuring movie genre
            
            var genresString = ""
            let genres = Globals.movieGenres
            
            for movieID in cell.genreIDS {
                
                for genre in genres {
                    
                    if movieID == genre.id {
                        genresString.append("\(genre.name). ")
                    }
                }
            }
            
            mediaGenres.text = String("\(genresString)".dropLast(2))
            
            // MARK: Configuring movie image
            
            if let imagePath = cell.posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 10)
                mediaImage.kf.indicatorType = .activity
                mediaImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "loading"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                //            {
                //                result in
                //                switch result {
                //                case .success(let value):
                //                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                //                case .failure(let error):
                //                    print("Job failed: \(error.localizedDescription)")
                //                }
                //            }
                let cashe = ImageCache.default
                cashe.memoryStorage.config.countLimit = 16
            } else {
                mediaImage.image = .strokedCheckmark
            }
            
        } else if cell is TVModel {
            let cell = cell as! TVModel
            
            mediaType = "tv"
            media.append(cell)
            mediaId = cell.id
            
            configureFavoriteButton(cell: cell)
            
            
            mediaName.text = cell.name
            mediaRating.text = "★ \(round((cell.voteAverage * 100))/100)"
            
            mediaOverview.text = cell.overview
            
            // MARK: Configuring tv genre
            
            var genresString = ""
            let genres = Globals.tvGenres
            
            for tvID in cell.genreIDS {
                
                for genre in genres {
                    
                    if tvID == genre.id {
                        genresString.append("\(genre.name). ")
                    }
                }
            }
            
            mediaGenres.text = String("\(genresString)".dropLast(2))
            
            // MARK: Configuring tv image
            
            if let imagePath = cell.posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 10)
                mediaImage.kf.indicatorType = .activity
                mediaImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "loading"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                //            {
                //                result in
                //                switch result {
                //                case .success(let value):
                //                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                //                case .failure(let error):
                //                    print("Job failed: \(error.localizedDescription)")
                //                }
                //            }
                let cashe = ImageCache.default
                cashe.memoryStorage.config.countLimit = 16
            } else {
                mediaImage.image = .strokedCheckmark
            }
        }
    }
    
    
    
    func configureFavoriteButton<T>(cell: T) {
        
        if cell is MovieModel {
            
            let cell = cell as! MovieModel
        
        // MARK: - Request favorite movies list
        
            DataManager.shared.requestFavoriteMovies { [weak self] success, favorites, _, _ in
                guard let self else { return }
                
                guard let favorites = favorites else { return }
                
                // MARK: - Check if movie is already in favorite list & set isFavorite property
                
                if favorites.contains(where: { $0.id == cell.id }) {
                    self.isFavorite = true
                    
                } else {
                    self.isFavorite = false
                }
            }
            
        } else if cell is TVModel {
            
            let cell = cell as! TVModel
            
            // MARK: - Request favorite tv shows list
            
            DataManager.shared.requestFavoriteTVShows { [weak self] success, favorites, _, _ in
                guard let self else { return }
                
                if let favorites = favorites {
                    
                    // MARK: - Check if tv show is already in favorite list & set isFavorite property
                    
                    if favorites.contains(where: { $0.id == cell.id }) {
                        self.isFavorite = true
                        
                    } else {
                        self.isFavorite = false
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        print("button tapped")
        
        if isFavorite {
            favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = false
            
            DataManager.shared.deleteFromFavorites(id: mediaId , type: mediaType) { [weak self] response in
                
                guard let self else { return }
                
                if response == 200 {
                    
                    if self.mediaType == "movie" {
                        
                        RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.mediaId) {
                        }
                        
                    } else if self.mediaType == "tv" {
                        
                        RealmManager.shared.delete(type: FavoriteTVRealm.self, primaryKey: self.mediaId) {
                        }
                    }
                }
            }
            
        } else {
            
            favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = true
            
            DataManager.shared.addToFavorites(id: mediaId, type: mediaType) { [weak self] response in
                
                guard let self else { return }
                
                if response == 200 {
                    if self.mediaType == "movie" {
                        
                        RealmManager.shared.saveFavoriteMoviesInRealm(movies: self.media as! [MovieModel])
                        
                    } else if self.mediaType == "tv" {
                        
                        RealmManager.shared.saveFavoriteTVInRealm(tvShows: self.media as! [TVModel])
                    }
                    
                    
                }
            }
        }
    }
}

