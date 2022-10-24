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
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var moviesArray: [MovieModel] = []
    
    private lazy var segmentedControlView: SegmentedControlView = {
        let segmentedControlView = SegmentedControlView()
        segmentedControlView.delegate = self
        segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControlView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.movieGenres = data
                
                DataManager.shared.requestMoviesByGenre(genre: "Action", page: 1) { [weak self] movies in
                    guard let self else { return }
                    
                    self.moviesArray = movies
                    self.configureSegmentedControl()
                    DispatchQueue.main.async {
                        self.moviesCollectionView.reloadData()
                    }
                }
                
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
        
        
        
        moviesCollectionView.register(UINib(nibName: "NewMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewMovieCollectionViewCell")
        
    }
    
    private func configureSegmentedControl() {
        let titles = Globals.movieGenres.map( { $0.name })
        let config = SegmentedControlConfiguration(titles: titles,
                                                   font: .systemFont(ofSize: 16, weight: .medium),
                                                   spacing: 40,
                                                   selectedLabelColor: .white,
                                                   unselectedLabelColor: .gray,
                                                   selectedLineColor: .white)
        segmentedControlView.configure(config)
        view.addSubview(segmentedControlView)
        
        NSLayoutConstraint.activate([
            segmentedControlView.bottomAnchor.constraint(equalTo: moviesCollectionView.topAnchor),
            segmentedControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControlView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.backgroundColor = .black
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        print("tapped")
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
        return moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "NewMovieCollectionViewCell", for: indexPath) as? NewMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: moviesArray, indexPath: indexPath)
        return cell
    }
    
    
}


extension NewMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 220)
    }
}


extension NewMovieViewController: SegmentedControlViewDelegate {
    
    func segmentedControl(didChange index: Int) {
        print("didChange index: \(index)")
        moviesCollectionView.contentOffset.x = 0
        DataManager.shared.requestMoviesByGenre(genre: Globals.movieGenres[index].name, page: 1) { [weak self] movies in
            guard let self else { return }
            
            self.moviesArray = movies
            
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
}

