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
    
    var someMovies: [MovieModel] = [] {
        didSet {
            for movie in someMovies {
                print("\(String(describing: movie.title))")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        someMovies = RealmManager.shared.getFavoritesFromRealm(type: .movie) as! [MovieModel]
        
        let nibFavouritesCell = UINib(nibName: "FavouritesTableViewCell", bundle: nil)
        favouritesTableView.register(nibFavouritesCell, forCellReuseIdentifier: "FavouritesTableViewCell")
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
            guard let self else {
                return
            }
            self.someMovies = favorites
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self else {
                    return
                }
                
                self.favouritesTableView.reloadData()
            }
        }
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            guard let self else {
                return
            }
            
            if result == true {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
                self.present(viewController, animated: true)
            } else {
                print("false result")
            }
            
        }
    }
    
}


extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // weak self + guard let self in each closure?
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
            guard let self else {
                return
            }
            
            DataManager.shared.deleteFromFavorites(id: self.someMovies[indexPath.row].id, type: "movie") { [weak self] result in
                print("delete from favorites result: \(result)")
                guard let self else {
                    return
                }
                
                if result == 200 {
                    
                    RealmManager.shared.delete(type: FavoriteMovieRealm.self, primaryKey: self.someMovies[indexPath.row].id) { [weak self] in
                        print("deleted from realm")
                        
                        guard let self else {
                            return
                        }
                        
                        RepositoryService.shared.movieFavoritesCashing { favorites in
                            print("favorites in cell cashing: \(favorites)")
                            self.someMovies = favorites
                            
                            DispatchQueue.main.async { [weak self] in
                                
                                guard let self else {
                                    return
                                }
                                print("some movies: \(self.someMovies.count)")
                                self.favouritesTableView.reloadData()
                                print("data in TV has been reloaded")
                            }
                        }
                        
                    }
                    
                    print(result)
                    
                }
            }
            
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
