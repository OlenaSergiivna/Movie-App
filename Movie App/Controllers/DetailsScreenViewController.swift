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
    
    // MARK: - Properties and outlets
    
    @IBOutlet weak var trailerPlayer: YTPlayerView!
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaName: UILabel!
    
    @IBOutlet weak var mediaRating: UIButton!
    
    @IBOutlet weak var mediaGenres: UILabel!
    
    @IBOutlet weak var mediaOverview: UILabel!
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var mainBackView: UIView!
    
    @IBOutlet weak var paddingView: UIView!
    
    @IBOutlet weak var detailsScreenCollectionView: UICollectionView!
    
    var media: [Any] = []
    
    var mediaId: Int = 0
    
    var mediaType: String = ""
    
    var castArray: [Cast] = []
    
    var reviewsArray: [ReviewsModel] = []
    
    var similarArray: [Any] = []
    
    
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
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
    
    var isExpanded = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
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
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.changeHeight()
            print("height after: \(self.collectionHeightConstraint.constant)")
            print("content height after: \(self.detailsScreenCollectionView.contentSize.height)")
        }
    }
    
    
    
    @IBAction func watchButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Making overview text expandable by tap
    
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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        detailsScreenCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.cellIdentifier)
            
        detailsScreenCollectionView.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: ReviewsCollectionViewCell.cellIdentifier)
            
        detailsScreenCollectionView.register(SimilarMediaCollectionViewCell.self, forCellWithReuseIdentifier: SimilarMediaCollectionViewCell.cellIdentifier)
            
        detailsScreenCollectionView.register(CastHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: CastHeaderView.headerIdentifier)
            
        detailsScreenCollectionView.register(ReviewsHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: ReviewsHeaderView.headerIdentifier)
            
        detailsScreenCollectionView.register(SimilarHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: SimilarHeaderView.headerIdentifier)
            
        detailsScreenCollectionView.backgroundColor = .black
        
        configureUI()
        setUpcollectionView()
        configureCompositionalLayout()
        
        self.view.layoutIfNeeded()
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
    
    func setUpcollectionView() {
        
        detailsScreenCollectionView.showsVerticalScrollIndicator = false
        detailsScreenCollectionView.delegate = self
        detailsScreenCollectionView.dataSource = self
        detailsScreenCollectionView.alwaysBounceVertical = false
        detailsScreenCollectionView.bounces = false
        detailsScreenCollectionView.translatesAutoresizingMaskIntoConstraints = false
        detailsScreenCollectionView.backgroundColor = .clear
        
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
        
        if let imagePath = movie.posterPath {
            
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
        } else {
            mediaImage.image = .strokedCheckmark
        }
        
        if movie.video != nil {
            configureTrailer(with: movie.id)
        }
        
        configureMediaCast(with: movie.id)
        
        configureReviews(mediaType: "movie", mediaId: movie.id)
        
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
        
        if let imagePath = tvShow.posterPath {
            
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
            
        } else {
            mediaImage.image = .strokedCheckmark
        }
        
        configureTrailer(with: tvShow.id)
        
        configureMediaCast(with: tvShow.id)
        
        configureReviews(mediaType: "tv", mediaId: tvShow.id)
        
        configureSimilarMedia(tvShow)
    }
    
    
    private func configureFavoriteButton<T>(_ data: T) {
        
        if let data = data as? MovieModel {
            
            // MARK: - Request favorite movies list
            
            DataManager.shared.requestFavoriteMovies { [weak self] success, favorites, _, _ in
                guard let self else { return }
                
                guard let favorites = favorites else { return }
                
                // MARK: - Check if movie is already in favorite list & set isFavorite property
                
                if favorites.contains(where: { $0.id == data.id }) {
                    self.isFavorite = true
                    
                } else {
                    self.isFavorite = false
                }
            }
            
        } else if let data = data as? TVModel {
            
            // MARK: - Request favorite tv shows list
            
            DataManager.shared.requestFavoriteTVShows { [weak self] success, favorites, _, _ in
                guard let self else { return }
                
                guard let favorites = favorites else { return }
                    
                    // MARK: - Check if tv show is already in favorite list & set isFavorite property
                    
                    if favorites.contains(where: { $0.id == data.id }) {
                        self.isFavorite = true
                        
                    } else {
                        self.isFavorite = false
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
                self.detailsScreenCollectionView.reloadData()
            }
        }
    }
    
    
    func configureReviews(mediaType: String, mediaId: Int) {
        DataManager.shared.getReviews(mediaType: mediaType, mediaId: mediaId) { [weak self] reviews in
            guard let self else { return }
           
            self.reviewsArray = reviews

            DispatchQueue.main.async {
                self.detailsScreenCollectionView.reloadData()
            }
        }
    }
    
    
    func configureSimilarMedia<T>(_ media: T) {
        
        if let media = media as? MovieModel {
            
            DataManager.shared.getSimilarMovies(movieId: media.id) { [weak self] movies in
                guard let self else { return }
                self.similarArray = movies
            }
            
        } else if let media = media as? TVModel {
            
            DataManager.shared.getSimilarTVShows(mediaId: media.id) { [weak self] tvShows in
                guard let self else { return }
                self.similarArray = tvShows
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


extension DetailsScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func changeHeight() {
        collectionHeightConstraint.constant = detailsScreenCollectionView.contentSize.height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return castArray.count
            
        case 1:
            return reviewsArray.count
            
        default:
            return similarArray.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.cellIdentifier, for: indexPath) as? CastCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.layoutIfNeeded()
            cell.configure(with: castArray[indexPath.row])
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCollectionViewCell.cellIdentifier, for: indexPath) as? ReviewsCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.layoutIfNeeded()
            cell.configure(with: reviewsArray[indexPath.row])
            return cell
            
        default:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMediaCollectionViewCell.cellIdentifier, for: indexPath) as? SimilarMediaCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.layoutIfNeeded()
            cell.configure(with: similarArray[indexPath.row])
            return cell
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard !reviewsArray.isEmpty else {
            return 2
        }
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
            
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CastHeaderView.headerIdentifier, for: indexPath) as? CastHeaderView else { return UICollectionReusableView() }
            
            return header
            
        case 1:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReviewsHeaderView.headerIdentifier, for: indexPath) as? ReviewsHeaderView else { return UICollectionReusableView() }
            
            return header
            
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SimilarHeaderView.headerIdentifier, for: indexPath) as? SimilarHeaderView else { return UICollectionReusableView() }
            
            return header
        }
    }
}


extension DetailsScreenViewController  {
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
            switch sectionIndex {
                
            case 0 :
                return DetailsScreenLayouts.shared.mediaCastSection()
                
            case 1:
                return DetailsScreenLayouts.shared.mediaReviewsSection()
                
            default:
                return DetailsScreenLayouts.shared.similarMediaSection()
            }
        }
        
        detailsScreenCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.width - 4) / 5, height: 160)
//    }
}
