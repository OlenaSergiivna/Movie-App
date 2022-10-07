//
//  GenresViewController.swift
//  Movie App
//
//  Created by user on 26.09.2022.
//

import UIKit

class GenresViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var genresTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibMovieCell = UINib(nibName: "GenresTableViewCell", bundle: nil)
        genresTableView.register(nibMovieCell, forCellReuseIdentifier: "GenresTableViewCell")
        
        DataManager.shared.requestMovieGenres { [weak self] data in
            
            Globals.genres.append(contentsOf: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                self.genresTableView.reloadData()
                print("genres fetched")
            }
        }
        
        DataManager.shared.requestTVGenres { [weak self] data in
           
            Globals.genres.append(contentsOf: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                self.genresTableView.reloadData()
            }
        }
        
        
        
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
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


extension GenresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.genres.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = genresTableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as? GenresTableViewCell else {
            return UITableViewCell()
        }
        
        cell.genreLabel.text = Globals.genres[indexPath.row].name
        
        DispatchQueue.main.async {
            DataManager.shared.requestMoviesByGenre(genre: cell.genreLabel.text!, page: 1) {  movies in
                
                cell.moviesArray = movies
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
        
        
    }
    
    
}
