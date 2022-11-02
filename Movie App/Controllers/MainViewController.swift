//
//  MainViewController.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    var moviesArray: [MovieModel] = []
    
    var tvArray: [TVModel] = []
    
    var trendyMediaArray: [TrendyMedia] = []
    
    var nowPlayingMoviesArray: [MovieModel] = []
    
    lazy var mainCollectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        KingsfisherMemoryService.shared.setCasheLimits()
        configureUI()
        setUpConstraints()
        configureCompositionalLayout()
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.movieGenres = data
                
                DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres.first?.name ?? "", page: 1) { [weak self] movies in
                    guard let self else { return }
                    
                    self.moviesArray = movies
            
                    DispatchQueue.main.async {
                        self.mainCollectionView.reloadData()
                    }
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
        
       //configureUsersGreetingsView()
        
        DataManager.shared.requestTVGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.tvGenres = data
                
                DataManager.shared.requestTVByGenre(genre: Globals.tvGenres.first?.name ?? "", page: 1) { [weak self] movies in
                    guard let self else { return }
                    
                    self.tvArray = movies
            
                    DispatchQueue.main.async {
                        self.mainCollectionView.reloadData()
                    }
                }
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
    
   
    func setUpConstraints(){
        mainCollectionView.setUp(to: view)
        
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
    }
    
    func configureUI(){
        view.backgroundColor = .black
        view.addSubview(mainCollectionView)
        
        configureTabBar()
        configureNavBar()
        configureUsersGreetingsView()
        
    }
    
    
    func configureUsersGreetingsView() {
        usernameLabel.text = "Hello, \(Globals.username)"
        avatarImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(Globals.avatar)")
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .darkContent
    //    }
    //
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            
            guard let self else { return }
            
            if result == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
                self.present(viewController, animated: true)
                
                KingsfisherMemoryService.shared.clearCasheKF()
                
            } else {
                print("false result")
            }
        }
    }
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            cell.movieImage.translatesAutoresizingMaskIntoConstraints = false
            cell.movieImage.backgroundColor = .systemBackground
            cell.movieImage.clipsToBounds = true
            cell.movieImage.contentMode = .scaleAspectFill
            cell.movieImage.layer.cornerRadius = 12
            return cell
            
        case 1:
            
            guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as? MediaCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureMovie(with: moviesArray, indexPath: indexPath)
            cell.mediaImage.translatesAutoresizingMaskIntoConstraints = false
            cell.mediaImage.backgroundColor = .systemBackground
            cell.mediaImage.clipsToBounds = true
            cell.mediaImage.contentMode = .scaleAspectFill
            cell.mediaImage.layer.cornerRadius = 12
            
            return cell
            
        case 2:
            
            guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as? MediaCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureTV(with: tvArray, indexPath: indexPath)
            cell.mediaImage.translatesAutoresizingMaskIntoConstraints = false
            cell.mediaImage.backgroundColor = .systemBackground
            cell.mediaImage.clipsToBounds = true
            cell.mediaImage.contentMode = .scaleAspectFill
            cell.mediaImage.layer.cornerRadius = 12
            
            return cell
            
        default:
            
            guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "TheatresCollectionViewCell", for: indexPath) as? TheatresCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: moviesArray, indexPath: indexPath)
            cell.movieImage.translatesAutoresizingMaskIntoConstraints = false
            cell.movieImage.backgroundColor = .systemBackground
            cell.movieImage.clipsToBounds = true
            cell.movieImage.contentMode = .scaleAspectFill
            cell.movieImage.layer.cornerRadius = 12
           
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
        } else if kind == "Footer" {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "InTheatresFooterView", for: indexPath) as? InTheatresFooterView else { return UICollectionReusableView() }
            
            return footer
        } else {
            return UICollectionReusableView()
        } 
        
    }
}


extension MainViewController {
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
            
        case 0:
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
                
                //destinationViewController.presentationController?.delegate = self
                destinationViewController.loadViewIfNeeded()
                destinationViewController.configure(with: trendyMediaArray[indexPath.row])
                navigationController?.present(destinationViewController, animated: true)
            }
        case 1:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
                
                //destinationViewController.presentationController?.delegate = self
                destinationViewController.loadViewIfNeeded()
                destinationViewController.configure(with: moviesArray[indexPath.row])
                navigationController?.present(destinationViewController, animated: true)
                
            }
        case 2:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
                
                //destinationViewController.presentationController?.delegate = self
                destinationViewController.loadViewIfNeeded()
                destinationViewController.configure(with: tvArray[indexPath.row])
                navigationController?.present(destinationViewController, animated: true)
                
            }
        default:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
                
                //destinationViewController.presentationController?.delegate = self
                destinationViewController.loadViewIfNeeded()
                destinationViewController.configure(with: moviesArray[indexPath.row])
                navigationController?.present(destinationViewController, animated: true)
                
            }
        }
    }
}



extension MainViewController: MoviesHeaderViewDelegate {
    
    func changeMovieGenre(index: Int) {
        
        mainCollectionView.scrollToItem(at:IndexPath(item: 0, section: 1), at: .right, animated: false)
        
        DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[index].name, page: 1) { [weak self] movies in
            guard let self else { return }
            
            self.moviesArray = movies
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.mainCollectionView.reloadItems(at: self.mainCollectionView.indexPathsForVisibleItems)
            }
        }
    }
    
    
    func openAllMoviesVC() {
  
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
            print(destinationViewController)
            
            destinationViewController.loadViewIfNeeded()
            navigationController?.pushViewController(destinationViewController, animated: true)
            
        }
    }
}


extension MainViewController: TVHeaderViewDelegate  {
    
    func openAllTVVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "TVViewController") as? TVViewController {
            print(destinationViewController)
            
            destinationViewController.loadViewIfNeeded()
            
            navigationController?.pushViewController(destinationViewController, animated: true)
            
        }
    }
    
    
    func changeTVGenre(index: Int) {
        mainCollectionView.scrollToItem(at:IndexPath(item: 0, section: 2), at: .right, animated: false)
        
        DataManager.shared.requestTVByGenre(genre: Globals.tvGenres[index].name, page: 1) { [weak self] movies in
            guard let self else { return }
            
            self.tvArray = movies
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.mainCollectionView.reloadItems(at: self.mainCollectionView.indexPathsForVisibleItems)
            }
        }
    }
}


extension UIView {
    
    func setUp(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 150).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 8).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -8).isActive = true
    }
}
