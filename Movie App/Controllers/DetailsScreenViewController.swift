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
    
    @IBOutlet weak var mediaRating: UILabel!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        trailerPlayer.delegate = self
        
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        
        mediaImage.clipsToBounds = true
        mediaImage.contentMode = .scaleAspectFill
        
        mediaImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        mediaImage.layer.cornerRadius = 20
        
        
        //        let gradientLayer = CAGradientLayer()
        //        gradientLayer.frame = mediaImage.bounds.integral
        //
        //        gradientLayer.type = .axial
        //        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.4).cgColor]
        //        gradientLayer.locations = [0.5, 1.0]
        //        gradientLayer.shouldRasterize = true
        //        mediaImage.layer.insertSublayer(gradientLayer, at: 0)
        //
        //
        //        DispatchQueue.main.async {
        //            self.mediaImage.layer.sublayers?[0].frame = self.mediaImage.bounds.integral
        //
        //        }
        
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        paddingView.clipsToBounds = true
        paddingView.contentMode = .scaleAspectFill
        paddingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        paddingView.layer.cornerRadius = 20

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
    
    func configure<T>(with cell: T) {
        
        if let cell = cell as? MovieModel {
            configureMovieCell(cell)
            
        } else if let cell = cell as? TVModel {
            configureTVCell(cell)
            
        } else if let cell = cell as? TrendyMedia {
            
            if cell.mediaType == "movie" {
                let cell = MovieModel(from: cell)
                configureMovieCell(cell)
                
            } else if cell.mediaType == "tv" {
                let cell = TVModel(from: cell)
                configureTVCell(cell)
            }
            
        } else if let cell = cell as? Media {
            switch cell {
                
            case .movie(let movie):
                configureMovieCell(movie)
                
            case .tvShow(let tvShow):
                configureTVCell(tvShow)
            }
        }
    }
    
    
    private func configureMovieCell(_ cell: MovieModel) {
        
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
        
        guard let imagePath = cell.posterPath else {
            
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
        
        guard cell.video != nil else { return }
        
        configureTrailer(with: cell.id)
        
        configureMediaCast(with: cell.id)
    }
    
    
    private func configureTVCell(_ cell: TVModel) {
        
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
        
        guard let imagePath = cell.posterPath else {
            
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
        
        configureTrailer(with: cell.id)
        
        configureMediaCast(with: cell.id)
    }
    
    
    private func configureFavoriteButton<T>(cell: T) {
        
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
