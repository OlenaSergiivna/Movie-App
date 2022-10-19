//
//  DetailsScreenViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher

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
    
    var mediaId: Int = 0
    
    var media: [MovieModel] = []
    
    var favoriteMovies: [MovieModel] = [] {
        didSet {
            if favoriteMovies.contains(where: { $0.id == mediaId }) {
                isFavorite = true
                
            } else {
               isFavorite = false
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.requestFavorites { [weak self] favorites, _ in
            guard let self else { return }
    
                self.favoriteMovies = favorites
            
         }
   
    }
    
    
    
    func configureMovie(with cell: MovieModel) {
        media.append(cell)
        mediaId = cell.id
        
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
    }
    
    
    
    func configureTV(with cell: TVModel) {
        
        mediaName.text = cell.name
        mediaRating.text = "★ \(round((cell.voteAverage * 100))/100)"
        
        mediaOverview.text = cell.overview
        
        // MARK: Configuring movie genre
        
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
            
        } else {
            mediaImage.image = .strokedCheckmark
        }
    }
    
    
    
    @IBAction func addToFavoritesPressed(_ sender: UIButton) {
        print("button tapped")
        
        
        
        if isFavorite {
            favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = false
            DataManager.shared.deleteFromFavorites(id: mediaId, type: "movie") { [weak self] response in
                print("delete movie from favorites result: \(response)")
                
                guard let self else { return }
                
                if response == 200 {
                    
                    RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.mediaId) {
                        print("deleted from realm")
                        
                    }
                }
            }
            
        } else {
            isFavorite = true
            favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoritesButton.tintColor = .systemRed
            
            DataManager.shared.addToFavorites(id: mediaId, type: "movie") { [weak self] response in
                print("added to favorites result: \(response)")
                
                guard let self else { return }
                
                if response == 200 {
                    
                    RealmManager.shared.saveFavoriteMoviesInRealm(movies: self.media)
                        print("added to realm")
                        
                    }
                }
            }
    }
    
}

