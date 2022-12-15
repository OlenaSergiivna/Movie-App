//
//  FavouritesViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var coverViewForGuestSession: UIView!
    
    var viewModel = FavouritesViewControllerViewModel()
    
    var favoriteMovies: [MovieModel] = []
    
    var favoriteTVShows: [TVModel] = []
    
    var loadingVC: LoadingViewController?
    
    let isGuestSession = UserDefaults.standard.bool(forKey: "isguestsession")
    
    let isWidthBigger = {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpNotifications()
        
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let nibFavouritesCell = UINib(nibName: "FavouritesCollectionViewCell", bundle: nil)
        favouritesCollectionView.register(nibFavouritesCell, forCellWithReuseIdentifier: "FavouritesCollectionViewCell")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favouritesCollectionView.frame = self.view.bounds
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        let isWidthBigger = {
            return UIScreen.main.bounds.width > UIScreen.main.bounds.height
        }
        
        if isWidthBigger() {
            tabBarController?.tabBar.isHidden = false
        } else {
            tabBarController?.tabBar.isHidden = true
        }
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
        
        tabBarController?.tabBar.isHidden = false
        configureSegmentedControl()
        
        guard !isGuestSession else { return }
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            
            if self.favoriteMovies.isEmpty {
                
                loadingVC = LoadingViewController()
                if let loadingVC = loadingVC {
                    add(loadingVC)
                }
            }
            
            RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
                guard let self else { return }
                
                self.favoriteMovies = favorites
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadingVC?.remove()
                    self.loadingVC = nil
                }
            }
            
        case 1:
            RepositoryService.shared.tvShowsFavoritesCashing { [weak self] favorites in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
            
        default:
            return
        }
    }
    
    
    func setUpNotifications() {
        let mainNotificationCenter = NotificationCenter.default
        
        mainNotificationCenter.addObserver(self, selector: #selector(appWasReturnedOnForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    @objc func appWasReturnedOnForeground() {
        
        if isWidthBigger() {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOutAndGetBackToLoginView(self)
    }
    
    
    func configureUI(){
        view.backgroundColor = .black
        configureNavBar()
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
        
        let topOffset = CGPoint(x: 0, y: -favouritesCollectionView.contentInset.top)
        favouritesCollectionView.setContentOffset(topOffset, animated: true)
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            
            //reload to update number of items
            favouritesCollectionView.reloadData()
            
            RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
                guard let self else { return }
                
                self.favoriteMovies = favorites
                
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
            
            RepositoryService.shared.tvShowsFavoritesCashing { [weak self] favorites in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController else { return }
        
        destinationViewController.presentationController?.delegate = self
        destinationViewController.loadViewIfNeeded()
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        
        switch selectedIndex {
            
        case 0:
            destinationViewController.configure(with: favoriteMovies[indexPath.row]) { [weak self] in
                guard let self else { return }
                self.navigationController?.present(destinationViewController, animated: true)
            }
            
        case 1:
            destinationViewController.configure(with: favoriteTVShows[indexPath.row]) { [weak self] in
                guard let self else { return }
                self.navigationController?.present(destinationViewController, animated: true)
            }
            
        default:
            return
        }
    }
    
// move to contextual menu

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
//            
//            guard let self else { return }
//            
//            DataManager.shared.deleteFromFavorites(id: self.favoriteMovies[indexPath.row].id, type: "movie") { [weak self] result in
//                
//                guard let self else { return }
//                
//                guard result == 200 else { return }
//                
//                RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.favoriteMovies[indexPath.row].id) {
//                    
//                    RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
//                        guard let self else { return }
//
//                        self.favoriteMovies = favorites
//
//                        DispatchQueue.main.async {
//                            self.favouritesCollectionView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//        
//        deleteAction.backgroundColor = .systemRed
//        
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
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
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        let selectedIndex = favoritesSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
                guard let self else { return }
                
                self.favoriteMovies = favorites
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
            
        case 1:
            RepositoryService.shared.tvShowsFavoritesCashing { [weak self] favorites in
                guard let self else { return }
                
                self.favoriteTVShows = favorites
                
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
            
        default:
            return
        }
    }
}


