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
    
    var someMovies: [Movie] = [] {
        didSet {
            for movie in someMovies {
                print("\(String(describing: movie.title))")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibFavouritesCell = UINib(nibName: "FavouritesTableViewCell", bundle: nil)
        favouritesTableView.register(nibFavouritesCell, forCellReuseIdentifier: "FavouritesTableViewCell")
        
        Repository.shared.dataCashingFavorites { [weak self] favorites in
            guard let self else {
                return
            }
            
            self.someMovies = favorites
            print("SM count: \(self.someMovies.count)")
            print("SM: \(self.someMovies)")
            
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
        return 250
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
            guard let self else {
                return
            }
            
            DataManager.shared.deleteFromFavorites(id: self.someMovies[indexPath.row].id, type: "movie") { [weak self] result in
                
                guard let self else {
                    return
                }
                
                RealmManager.shared.delete(primaryKey: self.someMovies[indexPath.row].id )
                self.someMovies.remove(at: indexPath.row)
                self.favouritesTableView.deleteRows(at: [indexPath], with: .fade)
                print(result)
                print("some movies: \(self.someMovies.count)")
                print("realm: \(RealmManager.shared.getFavoriteFromRealm().count)")
                
                // MARK: - Optional?
                //                if result == 200 {
                //                    DataManager.shared.requestFavorites { [weak self] data in
                //                        print("new data requested")
                //
                //                        guard let self else {
                //                            return
                //                        }
                //
                //                        self.favoriteMovies = data
                //
                //                        print("new data downloaded: \(self.favoriteMovies.count)")
                //                        DispatchQueue.main.async { [weak self] in
                //
                //                            guard let self else {
                //                                return
                //                            }
                //
                //                            self.favouritesTableView.reloadData()
                //                        }
                //                    }
                //                }
            }
            
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
