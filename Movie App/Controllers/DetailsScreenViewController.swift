//
//  DetailsScreenViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import youtube_ios_player_helper
import SkeletonView
import Swinject

class DetailsScreenViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    // MARK: - Properties and outlets
    
    @IBOutlet private weak var mediaImage: UIImageView!
    
    @IBOutlet private weak var mediaName: UILabel!
    
    @IBOutlet private weak var mediaRating: UIButton!
    
    @IBOutlet private weak var mediaGenres: UILabel!
    
    @IBOutlet private weak var mediaOverview: UILabel!
    
    @IBOutlet private weak var favoritesButton: HeartButton!
    
    @IBOutlet private weak var mainScrollView: UIScrollView!
    
    @IBOutlet private weak var mainBackView: UIView!
    
    @IBOutlet private weak var paddingView: UIView!
    
    @IBOutlet private weak var detailsScreenCollectionView: UICollectionView!
    
    private var detailsScreenLayouts = DetailsScreenLayouts()
    
    private var media: [Media] = []
    
    private var mediaId: Int = 0
    
    private var mediaType: String = ""
    
    private var castArray: [CastModel] = []
    
    private var similarArray: [Media] = []
    
    private var trailersArray: [TrailerModel] = []
    
    private let isGuestSession = UserDefaults.standard.bool(forKey: "isguestsession")
    
    @Injected private var detailsService: DetailsServiceProtocol
    
    var isSecondaryScreen: Bool = false
    
    @IBOutlet private weak var collectionHeightConstraint: NSLayoutConstraint!
    
    private var isFavorite: Bool = false {
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
    
    private var isExpanded = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "WatchProvidersViewController") as? WatchProvidersViewController else { return }
        destinationViewController.loadViewIfNeeded()
        
        destinationViewController.configure(mediaID: mediaId, mediaType: mediaType) { [weak self] in
            guard let self else { return }
            self.present(destinationViewController, animated: true)
        }
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
        
        detailsScreenCollectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: TrailerCollectionViewCell.cellIdentifier)
        
        detailsScreenCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.cellIdentifier)
        
        detailsScreenCollectionView.register(SimilarMediaCollectionViewCell.self, forCellWithReuseIdentifier: SimilarMediaCollectionViewCell.cellIdentifier)
        
        detailsScreenCollectionView.register(TrailerHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: TrailerHeaderView.headerIdentifier)
        
        detailsScreenCollectionView.register(CastHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: CastHeaderView.headerIdentifier)
        
        detailsScreenCollectionView.register(SimilarHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: SimilarHeaderView.headerIdentifier)
        
        detailsScreenCollectionView.backgroundColor = .black
        
        view.backgroundColor = .black
        configureNavBar()
        setUpcollectionView()
        configureCompositionalLayout()
        
        if !isGuestSession {
            favoritesButton.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkClouds), animation: nil, transition: .crossDissolve(0.25))
        }
        
        detailsScreenCollectionView.prepareSkeleton { (done) in
            self.detailsScreenCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkClouds), animation: nil, transition: .crossDissolve(0.25))
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isGuestSession {
            favoritesButton.isHidden = true
        } else {
            favoritesButton.isHidden = false
        }
        
        tabBarController?.tabBar.isHidden = true
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
    
    private func setUpcollectionView() {
        
        detailsScreenCollectionView.showsVerticalScrollIndicator = false
        detailsScreenCollectionView.delegate = self
        detailsScreenCollectionView.dataSource = self
        detailsScreenCollectionView.alwaysBounceVertical = false
        detailsScreenCollectionView.bounces = false
        detailsScreenCollectionView.translatesAutoresizingMaskIntoConstraints = false
        detailsScreenCollectionView.backgroundColor = .clear
    }
    
    
    // MARK: - Configuring DetailsScreen with data depends on tapped cell type
    
    func configure<T>(with data: T, completion: @escaping() -> Void) {
        
        if let data = data as? MovieModel {
            configureMovieCell(data)
            completion()
            
        } else if let data = data as? TVModel {
            configureTVCell(data)
            completion()
            
        } else if let data = data as? TrendyMedia {
            
            if data.mediaType == "movie" {
                let data = MovieModel(from: data)
                configureMovieCell(data)
                completion()
            } else if data.mediaType == "tv" {
                let data = TVModel(from: data)
                configureTVCell(data)
                completion()
            }
            
        } else if let data = data as? Media {
            switch data {
                
            case .movie(let movie):
                configureMovieCell(movie)
                completion()
                
            case .tvShow(let tvShow):
                configureTVCell(tvShow)
                completion()
            }
        }
    }
    
    
    private func configureFavButtonForMovie(_ data: MovieModel, completion: (()-> Void)? = nil) {
        
        guard !isGuestSession else { return }
        
        // MARK: - Request favorite movies list, check if movie is already in the favorites list. Get total favorite movies pages count.
        DataManager.shared.requestFavoriteMovies { [weak self] success, totalPages, favorites, _, _ in
            guard let self, let favorites, totalPages > 0 else {
                completion?()
                return
            }
            
            if favorites.contains(where: { $0.id == data.id }) {
                self.isFavorite = true
                completion?()
                return
            }
            
            // MARK: - If the movie wasn't found on the 1st page and total pages > 1, request all pages and check if the movie is in the favorites list
            guard totalPages > 1 else {
                completion?()
                return
            }
            
            var requestCompleted = 1
            
            for page in 2...totalPages {
                
                DataManager.shared.requestFavoriteMovies(page: page) { [weak self] success, _, favorites, _, _ in
                    guard let self, let favorites else {
                        completion?()
                        return
                    }
                    
                    if favorites.contains(where: { $0.id == data.id }) {
                        self.isFavorite = true
                        completion?()
                        return
                    }
                    
                    requestCompleted += 1
                    if requestCompleted == totalPages {
                        completion?()
                    }
                }
            }
        }
    }
    
    
    private func configureFavButtonForTVShow(_ data: TVModel, completion: (()-> Void)? = nil) {
        
        guard !isGuestSession else { return }
        
        // MARK: - Request favorite tv shows list, check if tv show is already in the favorites list. Get total favorite tv shows pages count.
        DataManager.shared.requestFavoriteTVShows { [weak self] success, totalPages, favorites, _, _ in
            guard let self, let favorites, totalPages > 0 else {
                completion?()
                return
            }
            
            if favorites.contains(where: { $0.id == data.id }) {
                self.isFavorite = true
                completion?()
                return
            }
            
            // MARK: - If the tv show wasn't found on the 1st page and total pages > 1, request all pages and check if the tv show is in the favorites list
            guard totalPages > 1 else {
                completion?()
                return
            }
            
            var requestCompleted = 1
            
            for page in 2...totalPages {
                
                DataManager.shared.requestFavoriteTVShows(page: page) { [weak self] success, _, favorites, _, _ in
                    guard let self, let favorites else {
                        completion?()
                        return
                    }
                    
                    if favorites.contains(where: { $0.id == data.id }) {
                        self.isFavorite = true
                        completion?()
                        return
                    }
                    
                    requestCompleted += 1
                    if requestCompleted == totalPages {
                        completion?()
                    }
                }
            }
        }
    }
    
    
    private func configureMovieCell(_ movie: MovieModel) {
        
        mediaType = "movie"
        media.append(.movie(movie))
        mediaId = movie.id
        
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
        
        configureFavButtonForMovie(movie) {
            self.favoritesButton.stopSkeletonAnimation()
            self.favoritesButton.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        }
        
        // MARK: Configuring movie image
        
        if let imagePath = movie.posterPath {
            
            KingsfisherManager.shared.setImage(imagePath: imagePath, setFor: mediaImage, scaleFactor: 3)
            
        } else {
            mediaImage.image = .strokedCheckmark
        }
        
        
        let group = DispatchGroup()
        group.enter()
        
        if movie.video != nil {
            configureTrailer(with: movie.id) {
                group.leave()
            }
        }
        
        group.enter()
        
        configureMediaCast(with: movie.id) {
            group.leave()
        }
        
        group.enter()
        
        configureSimilarMedia(movie) {
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.changeHeight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.detailsScreenCollectionView.stopSkeletonAnimation()
                self.detailsScreenCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        }
    }
    
    
    private func configureTVCell(_ tvShow: TVModel) {
        
        mediaType = "tv"
        media.append(.tvShow(tvShow))
        mediaId = tvShow.id
        
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
        
        configureFavButtonForTVShow(tvShow) {
            self.favoritesButton.stopSkeletonAnimation()
            self.favoritesButton.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
        }
        
        // MARK: Configuring tv image
        
        if let imagePath = tvShow.posterPath {
            
            KingsfisherManager.shared.setImage(imagePath: imagePath, setFor: mediaImage, scaleFactor: 3)
            
        } else {
            mediaImage.image = .strokedCheckmark
        }
        
        let group = DispatchGroup()
        group.enter()
        
        configureTrailer(with: tvShow.id) {
            group.leave()
        }
        
        group.enter()
        
        configureMediaCast(with: tvShow.id) {
            group.leave()
        }
        
        group.enter()
        
        configureSimilarMedia(tvShow) {
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            self.changeHeight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.detailsScreenCollectionView.stopSkeletonAnimation()
                self.detailsScreenCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        }
    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: HeartButton) {
        
        if isFavorite {
            favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = false
            
            DataManager.shared.deleteFromFavorites(id: mediaId , type: mediaType) { [weak self] success in
                
                guard let self else { return }
                guard success == true else { return }
                
                if self.mediaType == "movie" {
                    
                    RealmManager.shared.deleteFromRealm(type: FavoriteMovieRealm.self, primaryKey: self.mediaId) {
                        //add pop up
                    }
                    
                } else if self.mediaType == "tv" {
                    
                    RealmManager.shared.deleteFromRealm(type: FavoriteTVRealm.self, primaryKey: self.mediaId) {
                        //add pop up
                    }
                }
            }
            
        } else {
            
            favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoritesButton.tintColor = .systemRed
            isFavorite = true
            
            DataManager.shared.addToFavorites(id: mediaId, type: mediaType) { [weak self] success in
                
                guard let self else { return }
                guard success == true else { return }
                
                RealmManager.shared.saveFavoritesInRealm(media: self.media)
            }
        }
    }
    
    
    private func configureTrailer(with id: Int, completion: @escaping() -> Void) {
        
        DataManager.shared.getMediaTrailer(id: id, mediaType: mediaType) { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let data):
                guard let first = data.first else {
                    self.detailsScreenLayouts.isTrailerEmpty = true
                    completion()
                    return
                }
                
                self.trailersArray.append(first)
                
                DispatchQueue.main.async {
                    self.detailsScreenCollectionView.reloadData()
                    completion()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.detailsScreenLayouts.isTrailerEmpty = true
                completion()
            }
        }
    }
    
    
    private func configureMediaCast(with id: Int, completion: @escaping() -> Void) {
        
        DataManager.shared.getMediaCast(mediaType: mediaType, mediaId: id) { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let cast):
                
                guard !cast.isEmpty else {
                    self.detailsScreenLayouts.isCastEmpty = true
                    completion()
                    return
                }
                
                self.castArray = cast
                
                DispatchQueue.main.async {
                    self.detailsScreenCollectionView.reloadData()
                    completion()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.detailsScreenLayouts.isCastEmpty = true
                completion()
            }
        }
    }
    
    
    private func configureSimilarMedia<T>(_ media: T, completion: @escaping() -> Void) {

        guard isSecondaryScreen == false else {
            detailsScreenLayouts.isSimilarMediaEmpty = true
            completion()
            return
        }
        
        if let media = media as? MovieModel {
            
            DataManager.shared.getSimilarMovies(movieId: media.id) { [weak self] result in
                guard let self else { return }
                
                switch result {
                    
                case .success(let movies):
                    
                    guard !movies.isEmpty else {
                        self.detailsScreenLayouts.isSimilarMediaEmpty = true
                        completion()
                        return
                    }
                    movies.forEach { movie in
                        guard let backdropPath = movie.backdropPath, !backdropPath.isEmpty else {
                            return
                        }
                        self.similarArray.append(.movie(movie))
                    }
                    
                    DispatchQueue.main.async {
                        self.detailsScreenCollectionView.reloadData()
                        completion()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.detailsScreenLayouts.isSimilarMediaEmpty = true
                    completion()
                }
            }
        } else if let media = media as? TVModel {
            
            DataManager.shared.getSimilarTVShows(mediaId: media.id) { [weak self] result in
                guard let self else { return }
                
                switch result {
                    
                case .success(let tvShows):
                    
                    guard !tvShows.isEmpty else {
                        self.detailsScreenLayouts.isSimilarMediaEmpty = true
                        completion()
                        return
                    }
                    
                    tvShows.forEach { tvShow in
                        guard let backdropPath = tvShow.backdropPath, !backdropPath.isEmpty else {
                            return
                        }
                        self.similarArray.append(.tvShow(tvShow))
                    }
                    
                    DispatchQueue.main.async {
                        self.detailsScreenCollectionView.reloadData()
                        completion()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.detailsScreenLayouts.isSimilarMediaEmpty = true
                    completion()
                }
            }
        }
    }
    
    
    private func changeHeight() {
        self.detailsScreenCollectionView.reloadData()
        self.detailsScreenCollectionView.layoutIfNeeded()
        collectionHeightConstraint.constant = detailsScreenCollectionView.contentSize.height
    }
}


extension DetailsScreenViewController: YTPlayerViewDelegate {
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.clear
    }
}


extension DetailsScreenViewController: SkeletonCollectionViewDataSource {
    
    // MARK: Setup for SkeletonView
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 5
        default:
            return 1
        }
    }
    
    
    // MARK: Setup for DetailsScreenCollectionView
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        
        switch indexPath.section {
            
        case 0:
            return CastCollectionViewCell.cellIdentifier
        case 1:
            return TrailerCollectionViewCell.cellIdentifier
        default:
            return SimilarMediaCollectionViewCell.cellIdentifier
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return castArray.count
            
        case 1:
            return trailersArray.count
            
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionViewCell.cellIdentifier, for: indexPath) as? TrailerCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.layoutIfNeeded()
            cell.trailerPlayer.delegate = self
            cell.trailerPlayer.load(withVideoId: trailersArray[indexPath.row].key)
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
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
            
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CastHeaderView.headerIdentifier, for: indexPath) as? CastHeaderView else { return UICollectionReusableView() }
            
            return header
            
        case 1:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: TrailerHeaderView.headerIdentifier, for: indexPath) as? TrailerHeaderView else { return UICollectionReusableView() }
            
            return header
            
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SimilarHeaderView.headerIdentifier, for: indexPath) as? SimilarHeaderView else { return UICollectionReusableView() }
            
            return header
        }
    }
}


extension DetailsScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 2:
            detailsService.isSecondaryScreen = true
            detailsService.openDetailsScreen(with: similarArray[indexPath.row], viewController: self)
            
        default:
            return
        }
    }
}


extension DetailsScreenViewController  {
    
    private func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, enviroment in
            guard let self else { return nil }
            
            switch sectionIndex {
                
            case 0 :
                return self.detailsScreenLayouts.mediaCastSection()
                
            case 1:
                return self.detailsScreenLayouts.trailersSection()
                
            default:
                return self.detailsScreenLayouts.similarMediaSection()
            }
        }
        detailsScreenCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}


extension UIScrollView {
    var isOrthogonalScrollView: Bool {
        let isInCollectionView = superview as? UICollectionView != nil
        return isInCollectionView && subviews.contains { $0.isSkeletonable }
    }
    
    // to fix the error: ctrl+command+click on isSkeletonable and set extension as «public» and isSkeletonable as «open»
    
    override public var isSkeletonable: Bool {
        get {
            super.isSkeletonable || isOrthogonalScrollView
        }
        set {
            super.isSkeletonable = newValue
        }
    }
}
