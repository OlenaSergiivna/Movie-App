//
//  MainViewController.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit
import Swinject

class MainViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var mainBackView: UIView!
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    @IBOutlet weak var mainCVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var userDataView: UIView!
    
    @Injected private var detailsService: DetailsServiceProtocol
    
    var moviesArray: [MovieModel] = []
    
    var moviesSelectedIndex = 0
    
    var moviesPageCount = 1
    
    var moviesTotalPagesCount = 1
    
    
    var tvArray: [TVModel] = []
    
    var tvSelectedIndex = 0
    
    var tvPageCount = 1
    
    var tvTotalPagesCount = 1
    
    
    var trendyMediaArray: [TrendyMedia] = []
    
    var trendyPageCount = 1
    
    var trendyTotalPagesCount = 1
    
    
    var nowPlayingMoviesArray: [MovieModel] = []
    
    var nowPlayingPageCount = 1
    
    var nowPlayingTotalPagesCount = 1
    
    
    var displayStatus = false
    
    var loadingVC: LoadingViewController!
    
    let isWidthBigger = {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    var scrollTimer = Timer() {
        willSet {
            scrollTimer.invalidate()
        }
    }
    
    var scrollRunCount = 1 {
        didSet {
            print(scrollRunCount)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if trendyMediaArray.isEmpty {
            loadingVC = LoadingViewController()
            add(loadingVC)
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setUpTimerIfSectionIsVisible()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //set for MovieVC and TVShowsVC
        navigationController?.setNavigationBarHidden(false, animated: false)
        scrollTimer.invalidate()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       configureUsersGreetingsView()
        
        DispatchQueue.main.async {
            self.changeCollectionHeightDueToContentSize()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.register(UINib(nibName: "MediaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MediaCollectionViewCell")
        
        mainCollectionView.register(UINib(nibName: "PopularNowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularNowCollectionViewCell")
        
        mainCollectionView.register(UINib(nibName: "TheatresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TheatresCollectionViewCell")
        
        mainCollectionView.register(PopularHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: PopularHeaderView.headerIdentifier)
        
        mainCollectionView.register(MoviesHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: MoviesHeaderView.headerIdentifier)
        
        mainCollectionView.register(TVHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: TVHeaderView.headerIdentifier)
        
        mainCollectionView.register(InTheatresFooterView.self, forSupplementaryViewOfKind: "Footer", withReuseIdentifier: InTheatresFooterView.footerIdentifier)
        
        mainCollectionView.bounces = false
        mainCollectionView.bouncesZoom = false
        
        setUpNotifications()
        
        KingsfisherManager.shared.setCasheLimits()
        
        configureUI()
        configureCompositionalLayout()
        
        let group = DispatchGroup()
        group.enter()
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            guard statusCode == 200 else { return }
            
            Globals.movieGenres = data
            
            DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres.first?.name ?? "", page: 1) { [weak self] movies, totalPages in
                guard let self else { return }
                
                self.moviesArray = movies
                self.moviesTotalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                    group.leave()
                }
            }
        }
        
        group.enter()
        
        DataManager.shared.requestTVGenres { data, statusCode in
            
            guard statusCode == 200 else { return }
            
            Globals.tvGenres = data
            
            DataManager.shared.requestTVByGenre(genre: Globals.tvGenres.first?.name ?? "", page: 1) { [weak self] movies, totalPages in
                guard let self else { return }
                
                self.tvArray = movies
                self.tvTotalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                    group.leave()
                }
            }
        }
        
        group.enter()
        
        DataManager.shared.requestTrendyMedia { [weak self] media, totalPages in
            guard let self else { return }
            
            self.trendyMediaArray = media
            self.trendyTotalPagesCount = totalPages
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
                group.leave()
            }
        }
        
        group.enter()
        
        DataManager.shared.requestNowPlayingMovies { [weak self] media, totalPages in
            guard let self else { return }
            
            self.nowPlayingMoviesArray = media
            self.nowPlayingTotalPagesCount = totalPages
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.loadingVC.remove()
            self.loadingVC = nil
        }
    }
    

    func setUpNotifications() {
        let mainNotificationCenter = NotificationCenter.default
        
        mainNotificationCenter.addObserver(self, selector: #selector(appWasHiddenOnBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        mainNotificationCenter.addObserver(self, selector: #selector(appWasReturnedOnForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    @objc func appWasHiddenOnBackground() {
        scrollTimer.invalidate()
    }
    
    
    @objc func appWasReturnedOnForeground() {
        
        let selectedTabIndex = tabBarController?.selectedIndex
        
        if selectedTabIndex == 0 {
            setUpTimerIfSectionIsVisible()
        }
    }
    
    
    func setUpScrollTimer() {
        scrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.startTimer(theTimer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(scrollTimer, forMode: .common)
    }
    
    
    @objc func startTimer(theTimer: Timer) {
        MainTabLayouts.shared.flag = true
        mainCollectionView.collectionViewLayout.invalidateLayout()
        mainCollectionView.scrollToItem(at: IndexPath(item: scrollRunCount, section: 0), at: .centeredHorizontally, animated: true)
        MainTabLayouts.shared.flag = false
        mainCollectionView.collectionViewLayout.invalidateLayout()
        
        scrollRunCount += 1
        
        if scrollRunCount == trendyMediaArray.count {
            scrollRunCount = 0
        }
        
    }
    
    
    func configureTabBar() {
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = .black
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemPink]
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabAppearance.stackedLayoutAppearance.selected.iconColor = .systemPink
        tabAppearance.stackedLayoutAppearance.normal.iconColor = .white
        
        tabAppearance.compactInlineLayoutAppearance = tabAppearance.stackedLayoutAppearance
        tabAppearance.inlineLayoutAppearance = tabAppearance.stackedLayoutAppearance
        
        tabBarController?.tabBar.standardAppearance = tabAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
        
        tabBarController?.tabBar.items?[0].title = NSLocalizedString("Main", comment: "")
        tabBarController?.tabBar.items?[1].title = NSLocalizedString("Search", comment: "")
        tabBarController?.tabBar.items?[2].title = NSLocalizedString("Favourites", comment: "")
        
    }
    
    
    func configureNavBar() {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        barAppearance.backgroundColor = .clear
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    func configureUI() {
        view.backgroundColor = .black

        configureTabBar()
        configureNavBar()
    }
    
    
    func configureUsersGreetingsView() {
        
        guard let username = UserDefaults.standard.string(forKey: UserDefaultsManager.shared.getKeyFor(.username)), let avatar = UserDefaults.standard.string(forKey: UserDefaultsManager.shared.getKeyFor(.userAvatar)) else {
            
            usernameLabel.text = "Hello, user"
            return
        }
        
        usernameLabel.text = "Hello, \(username)"
        avatarImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(avatar)")
        avatarImage.layer.cornerRadius = 20
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        NetworkManager.shared.logOutAndGetBackToLoginView(self)
    }
}


extension MainViewController  {
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
            switch sectionIndex {
                
            case 0 :
                return MainTabLayouts.shared.popularNowSection()
                
            case 1 :
                return MainTabLayouts.shared.moviesSection()
                
            case 2:
                return MainTabLayouts.shared.tvSection()
                
            default:
                return MainTabLayouts.shared.nowInTheatresSection()
            }
        }
        
        mainCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}


extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0 :
            return trendyMediaArray.count
            
        case 1:
            return moviesArray.count
            
        case 2:
            return tvArray.count
            
        default:
            return nowPlayingMoviesArray.count
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularNowCollectionViewCell", for: indexPath) as? PopularNowCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            cell.configure(with: trendyMediaArray, indexPath: indexPath)
            return cell
            
        case 1:
            
            guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as? MediaCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureMovie(with: moviesArray, indexPath: indexPath)
            return cell
            
        case 2:
            
            guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as? MediaCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureTV(with: tvArray, indexPath: indexPath)
            return cell
            
        default:
            
            guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "TheatresCollectionViewCell", for: indexPath) as? TheatresCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: nowPlayingMoviesArray, indexPath: indexPath)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == "Header" else {
            
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "InTheatresFooterView", for: indexPath) as? InTheatresFooterView else { return UICollectionReusableView() }
            
            return footer
        }
        
        switch indexPath.section {
            
        case 0 :
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PopularHeaderView", for: indexPath) as? PopularHeaderView else { return UICollectionReusableView() }
            
            return header
            
        case 1 :
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoviesHeaderView", for: indexPath) as? MoviesHeaderView else { return UICollectionReusableView() }
            
            header.delegate = self
            header.segmentedControl.removeAllSegments()
            
            for (index, genre) in Globals.movieGenres.enumerated() {
                header.segmentedControl.insertSegment(withTitle: genre.name, at: index , animated: false)
            }
            header.segmentedControl.selectedSegmentIndex = moviesSelectedIndex
            
            return header
            
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TVHeaderView", for: indexPath) as? TVHeaderView else { return UICollectionReusableView() }
            
            header.delegate = self
            header.segmentedControl.removeAllSegments()
            
            for (index, genre) in Globals.tvGenres.enumerated() {
                header.segmentedControl.insertSegment(withTitle: genre.name, at: index , animated: false)
            }
            header.segmentedControl.selectedSegmentIndex = tvSelectedIndex
            
            return header
        }
    }
}



extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func changeCollectionHeightDueToContentSize() {
        mainCVHeightConstraint.constant = mainCollectionView.contentSize.height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            guard indexPath.row == trendyMediaArray.count - 1, trendyTotalPagesCount > trendyPageCount, displayStatus == false else { return }
            
            displayStatus = true
            trendyPageCount += 1
            
            DataManager.shared.requestTrendyMedia(page: trendyPageCount) { [weak self] media, _ in
                guard let self else { return }
                
                self.displayStatus = false
                
                self.trendyMediaArray.append(contentsOf: media)
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
            
        case 1:
            guard indexPath.row == moviesArray.count - 2, moviesTotalPagesCount > moviesPageCount, displayStatus == false else { return }
            
            displayStatus = true
            moviesPageCount += 1
            
            
            DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[moviesSelectedIndex].name, page: moviesPageCount) { [weak self] movies, _ in
                guard let self else { return }
                
                self.displayStatus = false
                
                let lastInArray = self.moviesArray.count
                self.moviesArray.append(contentsOf: movies)
                let newLastInArray = self.moviesArray.count
                let indexPaths = Array(lastInArray..<newLastInArray).map{IndexPath(item: $0, section: 1)}
                
                DispatchQueue.main.async {
                    self.mainCollectionView.insertItems(at: indexPaths)
                }
            }
            
        case 2:
            guard indexPath.row == tvArray.count - 2, tvTotalPagesCount > tvPageCount, displayStatus == false else { return }
            
            displayStatus = true
            tvPageCount += 1
            
            DataManager.shared.requestTVByGenre(genre: Globals.tvGenres[tvSelectedIndex].name, page: tvPageCount) { [weak self] tv, _ in
                guard let self else { return }
                
                self.displayStatus = false
                
                let lastInArray = self.tvArray.count
                self.tvArray.append(contentsOf: tv)
                let newLastInArray = self.tvArray.count
                let indexPaths = Array(lastInArray..<newLastInArray).map{IndexPath(item: $0, section: 2)}
                
                DispatchQueue.main.async {
                    self.mainCollectionView.insertItems(at: indexPaths)
                }
            }
            
        default:
            guard indexPath.row == nowPlayingMoviesArray.count - 1, nowPlayingTotalPagesCount > nowPlayingPageCount, displayStatus == false else { return }
            
            displayStatus = true
            nowPlayingPageCount += 1
            
            DataManager.shared.requestNowPlayingMovies(page: nowPlayingPageCount) { [weak self] media, _ in
                guard let self else { return }
                
                self.displayStatus = false
                
                self.nowPlayingMoviesArray.append(contentsOf: media)
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            detailsService.openDetailsScreen(with: trendyMediaArray[indexPath.row], viewController: self)
            scrollTimer.invalidate()
            
        case 1:
            detailsService.openDetailsScreen(with: moviesArray[indexPath.row], viewController: self)
            scrollTimer.invalidate()
            
        case 2:
            detailsService.openDetailsScreen(with: tvArray[indexPath.row], viewController: self)
            scrollTimer.invalidate()
            
            
        default:
            detailsService.openDetailsScreen(with: nowPlayingMoviesArray[indexPath.row], viewController: self)
            scrollTimer.invalidate()
        }
    }
}



extension MainViewController: MoviesHeaderViewDelegate {
    
    func changeMovieGenre(index: Int) {
        mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .right, animated: false)
        
        let items = self.mainCollectionView.indexPathsForVisibleItems.filter({ $0.section == 1 })
        self.mainCollectionView.reloadItems(at: items)
        
//        let indexPaths = (0..<moviesArray.count).map { IndexPath(item: $0, section: 1) }
//        mainCollectionView.reloadItems(at: indexPaths)
        
        moviesSelectedIndex = index
        moviesPageCount = 1
        //displayStatus = false
        
        DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[index].name, page: moviesPageCount) { [weak self] movies, totalPages in
            guard let self else { return }
            
            self.moviesArray = movies
            self.moviesTotalPagesCount = totalPages
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
                let items = self.mainCollectionView.indexPathsForVisibleItems.filter({ $0.section == 1 })
                self.mainCollectionView.reloadItems(at: items)
            }
        }
    }
    
    
    func openAllMoviesVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController else { return }
        
        destinationViewController.loadViewIfNeeded()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}


extension MainViewController: TVHeaderViewDelegate  {
    
    func openAllTVVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "TVViewController") as? TVViewController else { return }
        
        destinationViewController.loadViewIfNeeded()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
    func changeTVGenre(index: Int) {
        
        mainCollectionView.scrollToItem(at:IndexPath(item: 0, section: 2), at: .right, animated: false)
        
        let indexPaths = (0..<moviesArray.count).map { IndexPath(item: $0, section: 2) }
        mainCollectionView.reloadItems(at: indexPaths)
        
//        let items = self.mainCollectionView.indexPathsForVisibleItems.filter({ $0.section == 2 })
//        self.mainCollectionView.reloadItems(at: items)
        
        tvSelectedIndex = index
        tvPageCount = 1
        displayStatus = false
        
        DataManager.shared.requestTVByGenre(genre: Globals.tvGenres[index].name, page: tvPageCount) { [weak self] movies, totalPages in
            guard let self else { return }
            
            self.tvArray = movies
            self.tvTotalPagesCount = totalPages
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
                let items = self.mainCollectionView.indexPathsForVisibleItems.filter({ $0.section == 2 })
                self.mainCollectionView.reloadItems(at: items)
            }
        }
    }
}


extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        setUpTimerIfSectionIsVisible()
    }
    
    func setUpTimerIfSectionIsVisible() {
        
        let visibleFooterIndex = mainCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: "Footer")
        
        if visibleFooterIndex == [IndexPath(indexes: [2,0])] {
            scrollTimer.invalidate()
        } else {
            setUpScrollTimer()
        }
    }
}


extension MainViewController: PopularNowDelegate {
    //change to "did end dragging"
    func popularNowSwiped() {
        scrollTimer.invalidate()
    }
    
}


extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        setUpTimerIfSectionIsVisible()
    }
}
