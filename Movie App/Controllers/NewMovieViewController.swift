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
    
        cv.backgroundColor = .black
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(moviesCollectionView)
        setUpConstraints()
        configureCompositionalLayout()
        view.backgroundColor = .black
        tabBarItem.standardAppearance = tabBarItem.scrollEdgeAppearance
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.movieGenres = data
                
                DataManager.shared.requestMoviesByGenre(genre: "Action", page: 1) { [weak self] movies in
                    guard let self else { return }
                    
                    self.moviesArray = movies
                    //self.configureSegmentedControl()
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
        
        usernameLabel.text = "Hello, \(Globals.username)"
        avatarImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(Globals.avatar)")
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        
//        // MARK: - Set up tab bar appearance
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = tabBarController!.tabBar.bounds
//        blurView.autoresizingMask = .flexibleWidth
//        tabBarController!.tabBar.insertSubview(blurView, at: 0)

        
    }
    
//    private func configureSegmentedControl() {
//        let titles = Globals.movieGenres.map( { $0.name })
//        let config = SegmentedControlConfiguration(titles: titles,
//                                                   font: .systemFont(ofSize: 16, weight: .medium),
//                                                   spacing: 40,
//                                                   selectedLabelColor: .white,
//                                                   unselectedLabelColor: .gray,
//                                                   selectedLineColor: .white)
//        segmentedControlView.configure(config)
//        view.addSubview(segmentedControlView)
//
//        NSLayoutConstraint.activate([
//            segmentedControlView.bottomAnchor.constraint(equalTo: moviesCollectionView.topAnchor),
//            segmentedControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            segmentedControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            segmentedControlView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//
//
//    }
    
    func setUpConstraints(){
        moviesCollectionView.setUp(to: view)
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
    
    
    
    @IBAction func seeAllMoviesButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
            print(destinationViewController)
            
            destinationViewController.loadViewIfNeeded()
            navigationController?.pushViewController(destinationViewController, animated: true)
            
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
            return cell
            
        }
        
        
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == "Header" {
//
//            switch indexPath.section {
//            case 2 :
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterHeaderView.headerIdentifier, for: indexPath) as! FilterHeaderView
//                header.delegate = self
//                return header
//            default :
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VeganSectionHeaderView.headerIdentifier, for: indexPath) as! VeganSectionHeaderView
//                return header
//            }
//
//        }else {
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DividerFooterView.footerIdentifier, for: indexPath) as! DividerFooterView
//
//            return footer
//        }
//
//    }
    
    
    
    
    
}


//extension NewMovieViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 128, height: 220)
//    }
//}
//

//extension NewMovieViewController: SegmentedControlViewDelegate {
//
//    func segmentedControl(didChange index: Int) {
//        print("didChange index: \(index)")
//        moviesCollectionView.contentOffset.x = 0
//        DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[index].name, page: 1) { [weak self] movies in
//            guard let self else { return }
//
//            self.moviesArray = movies
//
//            DispatchQueue.main.async {
//                self.moviesCollectionView.reloadData()
//            }
//        }
//    }
//
//}

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
//        layout.register(SectionDecorationView.self, forDecorationViewOfKind: "SectionBackground")
        moviesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//extension FoodViewController: FilterActionDelegate {
//    func didTabFilterBTN() {
//        print("Open Filter")
//    }
//}


extension UIView {
    
    func setUp(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 180).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
}
