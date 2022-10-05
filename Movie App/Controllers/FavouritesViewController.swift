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
    
    var favouriteMovies: [Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibFavouritesCell = UINib(nibName: "FavouritesTableViewCell", bundle: nil)
        favouritesTableView.register(nibFavouritesCell, forCellReuseIdentifier: "FavouritesTableViewCell")
        
        DataManager.shared.requestFavourites { [weak self] data in
            
            guard let self else {
                return
            }
            
            self.favouriteMovies = data
           
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
        return favouriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as? FavouritesTableViewCell else {
            return UITableViewCell()
        }
        
        guard let imagePath = favouriteMovies[indexPath.row].posterPath, let title = favouriteMovies[indexPath.row].title else {
            return UITableViewCell()
        }
        cell.movieImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(imagePath)")
        cell.movieTitleLabel.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
