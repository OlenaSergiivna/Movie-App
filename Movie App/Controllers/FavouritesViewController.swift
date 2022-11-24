//
//  FavouritesViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var viewModel = FavouritesViewControllerViewModel()
    
    var someMovies: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let nibFavouritesCell = UINib(nibName: "FavouritesCollectionViewCell", bundle: nil)
        favouritesCollectionView.register(nibFavouritesCell, forCellWithReuseIdentifier: "FavouritesCollectionViewCell")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        favouritesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favouritesCollectionView.frame = self.view.bounds
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
            guard let self else { return }
            
            self.someMovies = favorites
            
            DispatchQueue.main.async {
                self.favouritesCollectionView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            guard let self else { return }
            
            guard result == true else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
            self.present(viewController, animated: true)
        }
    }
    
    
    func configureUI(){
        
        view.backgroundColor = .black
        configureNavBar()
    }
    
    
    func configureNavBar() {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = .clear
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
    }
}


extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("some movies: \(someMovies.count)")
        return someMovies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesCollectionViewCell", for: indexPath) as? FavouritesCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.layoutIfNeeded()
        cell.configure(with: someMovies[indexPath.row])
        
       return cell
    }
    
}


extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DetailsService.shared.openDetailsScreen(with: someMovies[indexPath.row], navigationController: navigationController)
    }
    
// move to contextual menu

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
//            
//            guard let self else { return }
//            
//            DataManager.shared.deleteFromFavorites(id: self.someMovies[indexPath.row].id, type: "movie") { [weak self] result in
//                
//                guard let self else { return }
//                
//                guard result == 200 else { return }
//                
//                RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.someMovies[indexPath.row].id) {
//                    
//                    RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
//                        guard let self else { return }
//                        
//                        self.someMovies = favorites
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
        
        let orientation = UIDevice.current.orientation
        
        guard orientation.isLandscape else {
            
            return CGSize(width: view.frame.width / 2.0, height: view.frame.height / 2.62)
        }
        
        return CGSize(width: view.frame.width / 4.0, height: view.frame.height / 1.1 )
    }
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        //favouritesCollectionView.reloadData()
//        favouritesCollectionView.collectionViewLayout.invalidateLayout()
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension FavouritesViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] data in
            guard let self else { return }
            
            self.someMovies = data
            
            DispatchQueue.main.async {
                self.favouritesCollectionView.reloadData()
                
            }
        }
    }
}


