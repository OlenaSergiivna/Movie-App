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
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            if result == true {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
                self?.present(viewController, animated: true)
            } else {
                print("false result")
            }
            
        }
    }
    
}


extension GenresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = genresTableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as? GenresTableViewCell else {
            return UITableViewCell()
        }
        cell.genreLabel.text = "Fantasy"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 240
        
       
    }
    
    
}
