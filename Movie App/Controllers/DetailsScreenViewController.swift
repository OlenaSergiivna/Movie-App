//
//  DetailsScreenViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper

// add popup message when media has been added to favorites list or deleted from it

class DetailsScreenViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBOutlet weak var trailerPlayer: YTPlayerView!
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaName: UILabel!
    
    @IBOutlet weak var mediaRating: UIButton!
    
    @IBOutlet weak var mediaGenres: UILabel!
    
    @IBOutlet weak var mediaOverview: UILabel!
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    var media: [Any] = []
    
    var mediaId: Int = 0
    
    var mediaType: String = ""
    
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
    
    var castArray: [Cast] = []
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var mainBackView: UIView!
    
    var isExpanded = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        trailerPlayer.delegate = self
        
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        mediaImage.clipsToBounds = true
        mediaImage.contentMode = .scaleAspectFill
        
        mediaImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mediaImage.layer.cornerRadius = 20
        
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        paddingView.clipsToBounds = true
        paddingView.contentMode = .scaleAspectFill
        paddingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        paddingView.layer.cornerRadius = 20

    }
    
    
    
    @IBAction func watchButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func owerviewButtonTapped(_ sender: UIButton) {
        
        if isExpanded {
            mediaOverview.numberOfLines = 3
            isExpanded = false
            
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
            
            
            
        } else {
            
            mediaOverview.numberOfLines = 0
            isExpanded = true
            
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet weak var paddingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCell")
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    
    
    func configureUI() {
        
        view.backgroundColor = .black
        configureNavBar()
        
    }
    
    
    
    private func configureNavBar() {
       
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        barAppearance.backgroundColor = .clear
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
    }
    
    
    // MARK: - Configuring DetailsScreen with data depends on tapped cell type
    
    func configure<T>(with data: T) {
        
        if let data = data as? MovieModel {
            configureMovieCell(data)
            
        } else if let data = data as? TVModel {
            configureTVCell(data)
            
        } else if let data = data as? TrendyMedia {
            
            if data.mediaType == "movie" {
                let data = MovieModel(from: data)
                configureMovieCell(data)
                
            } else if data.mediaType == "tv" {
                let data = TVModel(from: data)
                configureTVCell(data)
            }
            
        } else if let data = data as? Media {
            switch data {
                
            case .movie(let movie):
                configureMovieCell(movie)
                
            case .tvShow(let tvShow):
                configureTVCell(tvShow)
            }
        }
    }
    
    
    private func configureMovieCell(_ movie: MovieModel) {
        
        mediaType = "movie"
        media.append(movie)
        mediaId = movie.id
        
        configureFavoriteButton(movie)
        
        mediaName.text = movie.title
        
        if movie.voteAverage > 0 {
            mediaRating.setTitle("★ \(round((movie.voteAverage * 100))/100)", for: .normal)
        }
        
        mediaOverview.text = movie.overview
        
        // MARK: Configuring movie genre
        
        var yearGenresString = ""
        
        if let releaseYear = movie.releaseDate {
            yearGenresString = "\(releaseYear.dropLast(6)). "
        }
        
        let genres = Globals.movieGenres
        
        for movieID in movie.genreIDS {
            
            for genre in genres {
                
                if movieID == genre.id {
                    yearGenresString.append("\(genre.name) • ")
                }
            }
        }
        
        mediaGenres.text = String("\(yearGenresString)".dropLast(2))
        
        // MARK: Configuring movie image
        
        guard let imagePath = movie.posterPath else {
            
            mediaImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        mediaImage.kf.indicatorType = .activity
        mediaImage.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(3), //UIScreen.main.scale
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
        
        guard movie.video != nil else { return }
        
        configureTrailer(with: movie.id)
        
        configureMediaCast(with: movie.id)
        
        configureSimilarMedia(movie)
        
    }
    
    
    private func configureTVCell(_ tvShow: TVModel) {
        
        mediaType = "tv"
        media.append(tvShow)
        mediaId = tvShow.id
        
        configureFavoriteButton(tvShow)
        
        mediaName.text = tvShow.name
        
        if tvShow.voteAverage > 0 {
            mediaRating.setTitle("★ \(round((tvShow.voteAverage * 100))/100)", for: .normal)
        }
        
        mediaOverview.text = tvShow.overview
        
        // MARK: Configuring tv genre
        
        var yearGenresString = ""
        
        if let releaseYear = tvShow.firstAirDate {
            yearGenresString = "\(releaseYear.dropLast(6)). "
        }
        
        let genres = Globals.tvGenres
        
        for tvID in tvShow.genreIDS {
            
            for genre in genres {
                
                if tvID == genre.id {
                    yearGenresString.append("\(genre.name) • ")
                }
            }
        }
        
        mediaGenres.text = String("\(yearGenresString)".dropLast(2))
        
        // MARK: Configuring tv image
        
        guard let imagePath = tvShow.posterPath else {
            
            mediaImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        mediaImage.kf.indicatorType = .activity
        mediaImage.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(3),
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
        
        configureTrailer(with: tvShow.id)
        
        configureMediaCast(with: tvShow.id)
        
        configureSimilarMedia(tvShow)
    }
    
    
    private func configureFavoriteButton<T>(_ data: T) {
        
        if data is MovieModel {
            
            let cell = data as! MovieModel
            
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
            
        } else if data is TVModel {
            
            let cell = data as! TVModel
            
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
    
    
    private func configureTrailer(with id: Int) {
        
        DataManager.shared.getMediaTrailer(id: id, mediaType: mediaType) { [weak self] data in
            
            guard let self, let key = data.first?.key else { return }
            
            self.trailerPlayer.load(withVideoId: key)
        }
    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        
        if isFavorite {
            favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = false
            
            DataManager.shared.deleteFromFavorites(id: mediaId , type: mediaType) { [weak self] response in
                
                guard let self else { return }
                
                guard response == 200 else { return }
                
                if self.mediaType == "movie" {
                    
                    RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.mediaId) {
                    }
                    
                } else if self.mediaType == "tv" {
                    
                    RealmManager.shared.delete(type: FavoriteTVRealm.self, primaryKey: self.mediaId) {
                    }
                }
            }
            
        } else {
            
            favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = true
            
            DataManager.shared.addToFavorites(id: mediaId, type: mediaType) { [weak self] response in
                
                guard let self else { return }
                
                guard response == 200 else { return }
                
                if self.mediaType == "movie" {
                    
                    RealmManager.shared.saveFavoriteMoviesInRealm(movies: self.media as! [MovieModel])
                    
                } else if self.mediaType == "tv" {
                    
                    RealmManager.shared.saveFavoriteTVInRealm(tvShows: self.media as! [TVModel])
                }
            }
        }
    }
    
    
    func configureMediaCast(with id: Int) {
        
        DataManager.shared.getMediaCast(mediaType: mediaType, mediaId: id) { [weak self] cast in
            guard let self else { return }
            
            self.castArray = cast
            
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
            }
        }
    }
    
    
    func configureSimilarMedia<T>(_ media: T) {
        
        if let media = media as? MovieModel {
            
            DataManager.shared.getSimilarMovies(movieId: media.id) { [weak self] movie in
                guard let self else { return }
                
            }
            
        } else if let media = media as? TVModel {
            
            DataManager.shared.getSimilarTVShows(mediaId: media.id) { [weak self] tv in
                guard let self else { return }
                
            }
        }
    }
    
    func configureMediaProviders<T>(_ media: T) {
        if let media = media as? MovieModel {
        }
    }
}

extension DetailsScreenViewController: YTPlayerViewDelegate {
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.clear
    }
}


extension DetailsScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard !castArray.isEmpty else { return 0 }
        return castArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell else {
           
            return UICollectionViewCell()
        }
        
        cell.layoutIfNeeded()
        cell.configure(with: castArray[indexPath.row])
        return cell
    }
    
    
}


extension DetailsScreenViewController: UICollectionViewDelegate {
    
}


extension DetailsScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 160)
    }
}
