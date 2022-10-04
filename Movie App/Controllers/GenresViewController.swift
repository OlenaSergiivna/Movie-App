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
        
        NetworkManager.shared.requestMovieGenres { [weak self] data in
            guard let self = self else {
                return
            }
            
            Globals.genres.append(contentsOf: data)
            
            
            DispatchQueue.main.async {
                self.genresTableView.reloadData()
                print("genres fetched")
            }
        }
        
        NetworkManager.shared.requestTVGenres { [weak self] data in
            guard let self = self else {
                return
            }
            
            Globals.genres.append(contentsOf: data)
            
            
            DispatchQueue.main.async {
                self.genresTableView.reloadData()
            }
        }
        
        
        
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            guard let self = self else {
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
        
        //        cell.genresCollectionView.tag = indexPath.row
        //        print("Tag: \(indexPath.row)")
        cell.genreLabel.text = Globals.genres[indexPath.row].name
        
        DispatchQueue.main.async {
            NetworkManager.shared.requestMoviesByGenre(genre: cell.genreLabel.text!, page: 1) {  movies in
                
                cell.moviesArray = movies
                print("!TV indexPath.row: \(indexPath.row) - \(cell.genreLabel.text!)!")
            }
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
        
        
    }
    
    
}
