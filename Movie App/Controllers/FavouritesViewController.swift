//
//  FavouritesViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var viewModel = FavouritesViewControllerViewModel()
    
    var someMovies: [MovieModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
            guard let self else { return }
            
            self.someMovies = favorites
            
            DispatchQueue.main.async {
                self.favouritesTableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        let nibFavouritesCell = UINib(nibName: "FavouritesTableViewCell", bundle: nil)
        favouritesTableView.register(nibFavouritesCell, forCellReuseIdentifier: "FavouritesTableViewCell")
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            guard let self else { return }
            
            guard result == true else {
                print("false result")
                return
            }
            
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
        barAppearance.backgroundColor = .black
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
    }
}


extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someMovies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as? FavouritesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: someMovies[indexPath.row])
        
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DetailsService.shared.openDetailsScreen(with: someMovies[indexPath.row], navigationController: navigationController)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
            
            guard let self else { return }
            
            DataManager.shared.deleteFromFavorites(id: self.someMovies[indexPath.row].id, type: "movie") { [weak self] result in
                
                guard let self else { return }
                
                guard result == 200 else { return }
                
                RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.someMovies[indexPath.row].id) {
                    
                    RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
                        guard let self else { return }
                        
                        self.someMovies = favorites
                        
                        DispatchQueue.main.async {
                            self.favouritesTableView.reloadData()
                        }
                    }
                }
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension FavouritesViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] data in
            guard let self else { return }
            
            self.someMovies = data
            
            DispatchQueue.main.async {
                self.favouritesTableView.reloadData()
                
            }
        }
    }
}
