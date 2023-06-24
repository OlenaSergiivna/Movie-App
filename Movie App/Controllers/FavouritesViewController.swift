//
//  FavouritesViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Swinject

class FavouritesViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var coverViewForGuestSession: UIView!
    
    @Injected private var detailsService: DetailsServiceProtocol
    
    var viewModel = FavouritesViewControllerViewModel()
    
    var favoriteMovies: [MovieModel] = []
    
    var favoriteTVShows: [TVModel] = []
    
    var loadingVC: LoadingViewController?
    
    let isGuestSession = UserDefaults.standard.bool(forKey: "isguestsession")
    
    let isWidthBigger = {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    var pageCount = 1
    
    var displayStatus = false
    
    var totalPagesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureNavBar()
        
        guard !isGuestSession else { return }
        
        loadingVC = LoadingViewController()
        if let loadingVC = loadingVC {
            add(loadingVC)
        }
        
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let nibFavouritesCell = UINib(nibName: "FavouritesCollectionViewCell", bundle: nil)
        favouritesCollectionView.register(nibFavouritesCell, forCellWithReuseIdentifier: "FavouritesCollectionViewCell")
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] favorites, totalPageCount in
            guard let self else { return }
            
            self.favoriteMovies = favorites
            self.totalPagesCount = totalPageCount
            
            DispatchQueue.main.async {
                self.favouritesCollectionView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadingVC?.remove()
                self.loadingVC = nil
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favouritesCollectionView.frame = self.view.bounds
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isGuestSession {
            coverViewForGuestSession.isHidden = false
            favouritesCollectionView.isHidden = true
        } else {
            coverViewForGuestSession.isHidden = true
            favouritesCollectionView.isHidden = false
        }
        
        configureSegmentedControl()
        
        guard !isGuestSession else { return }
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            
            RepositoryService.shared.movieFavoritesCashing { [weak self] favorites, totalPages in
                guard let self else { return }
                
                self.favoriteMovies = favorites
                self.totalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                
                guard self.pageCount > 1 else { return }
                
                for page in 2...self.pageCount {
                    
                    RepositoryService.shared.movieFavoritesCashing(page: page) { [weak self] favorites, _ in
                        guard let self else { return }
                        
                        self.favoriteMovies = favorites
                        
                        DispatchQueue.main.async {
                            self.favouritesCollectionView.reloadData()
                        }
                    }
                }
            }
            
        case 1:
            
            RepositoryService.shared.tvShowsFavoritesCashing { [weak self] favorites, totalPages in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                self.totalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                
                guard self.pageCount > 1 else { return }
                
                for page in 2...self.pageCount {
                    
                    RepositoryService.shared.tvShowsFavoritesCashing(page: page) { [weak self] favorites, _ in
                        guard let self else { return }
                        
                        self.favoriteTVShows = favorites
                        
                        DispatchQueue.main.async {
                            self.favouritesCollectionView.reloadData()
                        }
                    }
                }
            }
            
        default:
            self.favouritesCollectionView.reloadData()
        }
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOutAndGetBackToLoginView(self)
    }
    
    
    func configureNavBar() {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithDefaultBackground()
        barAppearance.backgroundColor = .black
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
    }
    
    
    func configureSegmentedControl() {
        favoritesSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        favoritesSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        guard !isGuestSession else { return }
        
        pageCount = 1
        
        let topOffset = CGPoint(x: 0, y: -favouritesCollectionView.contentInset.top)
        favouritesCollectionView.setContentOffset(topOffset, animated: true)
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            
            //reload to update number of items
            favouritesCollectionView.reloadData()
            
            RepositoryService.shared.movieFavoritesCashing { [weak self] favorites, totalPages in
                guard let self else { return }
                
                self.favoriteMovies = favorites
                self.totalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
            
        case 1:
            
            //reload to update number of items
            favouritesCollectionView.reloadData()
            
            if self.favoriteTVShows.isEmpty {
                
                loadingVC = LoadingViewController()
                if let loadingVC = loadingVC {
                    add(loadingVC)
                }
            }
            
            RepositoryService.shared.tvShowsFavoritesCashing { [weak self] favorites, totalPages in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                self.totalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadingVC?.remove()
                    self.loadingVC = nil
                }
                
            }
            
        default:
            return
        }
    }
    
}


extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            return favoriteMovies.count
            
        case 1:
            return favoriteTVShows.count
            
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesCollectionViewCell", for: indexPath) as? FavouritesCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.layoutIfNeeded()
        
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            cell.configure(with: favoriteMovies[indexPath.row])
            
        case 1:
            cell.configure(with: favoriteTVShows[indexPath.row])
            
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}


extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            detailsService.openDetailsScreen(with: favoriteMovies[indexPath.row], viewController: self)
            
        case 1:
            detailsService.openDetailsScreen(with: favoriteTVShows[indexPath.row], viewController: self)
            
        default:
            return
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            
            guard indexPath.row == favoriteMovies.count - 2, totalPagesCount > pageCount, displayStatus == false else {
                return
            }
            
            displayStatus = true
            pageCount += 1
            
            RepositoryService.shared.movieFavoritesCashing(page: pageCount) { [weak self] favorites, _ in
                guard let self else { return }
                
                self.favoriteMovies = favorites
               
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                self.displayStatus = false
            }
            
        case 1:
            guard indexPath.row == favoriteTVShows.count - 5, totalPagesCount > pageCount, displayStatus == false else {
                return
            }
            
            displayStatus = true
            pageCount += 1
            
            RepositoryService.shared.tvShowsFavoritesCashing(page: pageCount) { [weak self] favorites, _  in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                self.displayStatus = false
            }
            
        default:
            return
        }
    }
}


extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        guard isWidthBigger() else {
            
            return CGSize(width: view.frame.width / 2.0, height: view.frame.height / 2.62)
        }
        
        return CGSize(width: view.frame.width / 4.0, height: view.frame.height / 1.2 )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension FavouritesViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        //test with pageCount parameter
        switch selectedIndex {
            
        case 0:
            RepositoryService.shared.movieFavoritesCashing { [weak self] favorites, totalPages in
                guard let self else { return }
                
                self.favoriteMovies = favorites
                self.totalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
            
        case 1:
            RepositoryService.shared.tvShowsFavoritesCashing { [weak self] favorites, totalPages in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                self.totalPagesCount = totalPages
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
            
        default:
            return
        }
    }
}


