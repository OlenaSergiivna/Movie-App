//
//  NewMovieViewController.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit

class NewMovieViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    var moviesArray: [MovieModel] = []
    
    var trendyMediaArray: [TrendyMedia] = []
    
    lazy var moviesCollectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(UINib(nibName: "NewMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewMovieCollectionViewCell")
        
        cv.register(UINib(nibName: "PopularNowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularNowCollectionViewCell")
        
        cv.register(PopularHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: PopularHeaderView.headerIdentifier)
        
        cv.register(MoviesHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: MoviesHeaderView.headerIdentifier)
        
        cv.backgroundColor = .black
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        self.moviesCollectionView.reloadData()
                    }
                }
            }
        }
        
        
        DataManager.shared.requestTrendyMedia { [weak self] media in
            guard let self else { return }
            
            self.trendyMediaArray = media
            
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
        
       configureUsersGreetingsView()
        
        //        // MARK: - Set up tab bar appearance
        //        let blurEffect = UIBlurEffect(style: .dark)
        //        let blurView = UIVisualEffectView(effect: blurEffect)
        //        blurView.frame = tabBarController!.tabBar.bounds
        //        blurView.autoresizingMask = .flexibleWidth
        //        tabBarController!.tabBar.insertSubview(blurView, at: 0)
        
        
    }
    
   
    func setUpConstraints(){
        moviesCollectionView.setUp(to: view)
        
    }
    
    
    func configureUI(){
        view.backgroundColor = .black
        tabBarItem.standardAppearance = tabBarItem.scrollEdgeAppearance
        view.addSubview(moviesCollectionView)
    }
    
    func configureUsersGreetingsView() {
        usernameLabel.text = "Hello, \(Globals.username)"
        avatarImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(Globals.avatar)")
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            
            guard let self else { return }
            
            if result == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
                self.present(viewController, animated: true)
            } else {
                print("false result")
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
}



extension NewMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0 :
            return trendyMediaArray.count
        default:
            return moviesArray.count
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
            
        default:
            
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "NewMovieCollectionViewCell", for: indexPath) as? NewMovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: moviesArray, indexPath: indexPath)
            cell.movieImage.translatesAutoresizingMaskIntoConstraints = false
            cell.movieImage.backgroundColor = .systemBackground
            cell.movieImage.clipsToBounds = true
            cell.movieImage.contentMode = .scaleAspectFill
            cell.movieImage.layer.cornerRadius = 12
            print(indexPath)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "Header" {
            
            switch indexPath.section {
            case 0 :
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PopularHeaderView", for: indexPath) as? PopularHeaderView else { return UICollectionReusableView() }
                
                return header
            default :
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoviesHeaderView", for: indexPath) as? MoviesHeaderView else { return UICollectionReusableView() }
                header.delegate = self
                
                header.segmentedControl.removeAllSegments()
                for (index, genre) in Globals.movieGenres.enumerated() {
                    header.segmentedControl.insertSegment(withTitle: genre.name, at: index , animated: true)
                }
                header.segmentedControl.selectedSegmentIndex = 0
                
                return header
            }
        } else {
            return UICollectionReusableView()
        }
    }
}


extension NewMovieViewController {
    
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0 :
                return MainTabLayouts.shared.popularNowSection()
            default :
                return MainTabLayouts.shared.moviesSection()
            }
        }
        
        moviesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}


extension UIView {
    
    func setUp(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 180).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 8).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -8).isActive = true
    }
}


extension NewMovieViewController: MoviesHeaderViewDelegate {
    
    func changeMovieGenre(index: Int) {
        
        moviesCollectionView.scrollToItem(at:IndexPath(item: 0, section: 1), at: .right, animated: false)
        
        DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[index].name, page: 1) { [weak self] movies in
            guard let self else { return }
            
            self.moviesArray = movies
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.moviesCollectionView.reloadItems(at: self.moviesCollectionView.indexPathsForVisibleItems)
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
