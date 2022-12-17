//
//  MainViewController.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    var moviesArray: [MovieModel] = []
    
    var tvArray: [TVModel] = []
    
    var trendyMediaArray: [TrendyMedia] = []
    
    var nowPlayingMoviesArray: [MovieModel] = []
    
    let isWidthBigger = {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    lazy var mainCollectionView : UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.bouncesZoom = false
        
        cv.register(UINib(nibName: "MediaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MediaCollectionViewCell")
        
        cv.register(UINib(nibName: "PopularNowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularNowCollectionViewCell")
        
        cv.register(UINib(nibName: "TheatresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TheatresCollectionViewCell")
        
        cv.register(PopularHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: PopularHeaderView.headerIdentifier)
        
        cv.register(MoviesHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: MoviesHeaderView.headerIdentifier)
        
        cv.register(TVHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: TVHeaderView.headerIdentifier)
        
        cv.register(InTheatresFooterView.self, forSupplementaryViewOfKind: "Footer", withReuseIdentifier: InTheatresFooterView.footerIdentifier)
        
        cv.backgroundColor = .black
        return cv
    }()
    
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
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        
        setUpTimerIfSectionIsVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //navigationController?.navigationBar.isHidden = false
        scrollTimer.invalidate()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if isWidthBigger() {
            mainCollectionView.frame = self.view.bounds
        }
        
        //navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNotifications()
        
        KingsfisherManager.shared.setCasheLimits()
        
        configureUI()
        setUpMainCV()
        configureCompositionalLayout()
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            guard statusCode == 200 else {
                return
            }
            
            Globals.movieGenres = data
            
            DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres.first?.name ?? "", page: 1) { [weak self] movies in
                guard let self else { return }
                
                self.moviesArray = movies
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        }
        
        
        DataManager.shared.requestTVGenres { data, statusCode in
            
            guard statusCode == 200 else {
                return
            }
            
            Globals.tvGenres = data
            
            DataManager.shared.requestTVByGenre(genre: Globals.tvGenres.first?.name ?? "", page: 1) { [weak self] movies in
                guard let self else { return }
                
                self.tvArray = movies
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        }
        
        
        DataManager.shared.requestTrendyMedia { [weak self] media in
            guard let self else { return }
            
            self.trendyMediaArray = media
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
        
        
        DataManager.shared.requestNowPlayingMovies { [weak self] data in
            guard let self else { return }
            
            self.nowPlayingMoviesArray = data
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
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
        
        tabBarController?.tabBar.isHidden = false
        print("not hidden")
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
        
        if scrollRunCount == 20 {
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
        
        tabBarController?.tabBar.standardAppearance = tabAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
        
        tabBarController?.tabBar.items?[0].title = NSLocalizedString("Main", comment: "")
        tabBarController?.tabBar.items?[1].title = NSLocalizedString("Search", comment: "")
        tabBarController?.tabBar.items?[2].title = NSLocalizedString("Favourites", comment: "")
        
    }
    
    
    func configureNavBar() {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = .black
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    func configureUI(){
        view.backgroundColor = .black
        view.addSubview(mainCollectionView)
        
        configureTabBar()
        //configureNavBar()
        configureUsersGreetingsView()
        
    }
    
    
    func configureUsersGreetingsView() {
        
        guard let username = UserDefaults.standard.string(forKey: "username"), let avatar = UserDefaults.standard.string(forKey: "useravatar") else {
            
            usernameLabel.text = "Hello, user"
            return
        }
        
        usernameLabel.text = "Hello, \(username)"
        avatarImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(avatar)")
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    
    func setUpMainCV() {
        
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 16).isActive = true
        mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
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
            
            cell.configure(with: trendyMediaArray, indexPath: indexPath)
            cell.delegate = self
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
            
            cell.configure(with: moviesArray, indexPath: indexPath)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "Header" {
            
            switch indexPath.section {
                
            case 0 :
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PopularHeaderView", for: indexPath) as? PopularHeaderView else { return UICollectionReusableView() }
                
                return header
                
            case 1 :
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoviesHeaderView", for: indexPath) as? MoviesHeaderView else { return UICollectionReusableView() }
                
                header.delegate = self
                header.segmentedControl.removeAllSegments()
                
                for (index, genre) in Globals.movieGenres.enumerated() {
                    header.segmentedControl.insertSegment(withTitle: genre.name, at: index , animated: true)
                }
                header.segmentedControl.selectedSegmentIndex = 0
                
                return header
                
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TVHeaderView", for: indexPath) as? TVHeaderView else { return UICollectionReusableView() }
                
                header.delegate = self
                header.segmentedControl.removeAllSegments()
                
                for (index, genre) in Globals.tvGenres.enumerated() {
                    header.segmentedControl.insertSegment(withTitle: genre.name, at: index , animated: true)
                }
                header.segmentedControl.selectedSegmentIndex = 0
                
                return header
            }
            
        } else {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "InTheatresFooterView", for: indexPath) as? InTheatresFooterView else { return UICollectionReusableView() }
            
            return footer
        }
    }
}


extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            DetailsService.shared.openDetailsScreen(with: trendyMediaArray[indexPath.row], navigationController: navigationController)
            
        case 1:
            DetailsService.shared.openDetailsScreen(with: moviesArray[indexPath.row], navigationController: navigationController)
            
        case 2:
            DetailsService.shared.openDetailsScreen(with: tvArray[indexPath.row], navigationController: navigationController)
            
            
        default:
            DetailsService.shared.openDetailsScreen(with: moviesArray[indexPath.row], navigationController: navigationController)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if isWidthBigger() {
            usernameLabel.isHidden = false
            avatarImage.isHidden = false
            secondaryTextLabel.isHidden = false
        } else {
            usernameLabel.isHidden = true
            avatarImage.isHidden = true
            secondaryTextLabel.isHidden = true
        }
    }
}



extension MainViewController: MoviesHeaderViewDelegate {
    
    func changeMovieGenre(index: Int) {
        
        mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .right, animated: false)
        
        DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[index].name, page: 1) { [weak self] movies in
            guard let self else { return }
            
            self.moviesArray = movies
           
            DispatchQueue.main.async {
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
        
        DataManager.shared.requestTVByGenre(genre: Globals.tvGenres[index].name, page: 1) { [weak self] movies in
            guard let self else { return }
            
            self.tvArray = movies
            
            DispatchQueue.main.async {
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
    
    func popularNowSwiped() {
        scrollTimer.invalidate()
    }
    
}

