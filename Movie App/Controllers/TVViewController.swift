//
//  TVViewController.swift
//  Movie App
//
//  Created by user on 15.10.2022.
//

import UIKit

class TVViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var tvTableView: UITableView!
    
    var tappedCell: TVModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let nibMovieCell = UINib(nibName: "TVTableViewCell", bundle: nil)
        tvTableView.register(nibMovieCell, forCellReuseIdentifier: "TVTableViewCell")
        
        // MARK: - Fetch tv shows data
        
        loadContent()
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            
            guard let self else { return }
            
            if result == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
                self.present(viewController, animated: true)
                
            } else {
                print("false result")
            }
        }
    }
    
    
    
    func loadContent() {
        
        let loadingVC = LoadingViewController()
        add(loadingVC)
        
        DataManager.shared.requestTVGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.tvGenres = data
                
                DispatchQueue.main.async {
                    
                    self.tvTableView.reloadData()

                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    
                    loadingVC.remove()
                    
                }
            }
        }
    }
}



extension TVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.tvGenres.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tvTableView.dequeueReusableCell(withIdentifier: "TVTableViewCell", for: indexPath) as? TVTableViewCell else {
            return UITableViewCell()
        }
        
        // Set cell's delegate
        
        cell.cellDelegate = self
        
        cell.genreLabel.text = Globals.tvGenres[indexPath.row].name
        
        
        DispatchQueue.main.async {
            DataManager.shared.requestTVByGenre(genre: cell.genreLabel.text!, page: 1) { tv in
                
                cell.tvArray = tv
            }
        }

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsScreen" {
            if let destinationViewController = segue.destination as? DetailsScreenViewController {
                destinationViewController.loadViewIfNeeded()
                destinationViewController.configureTV(with: tappedCell)
            }
            
            
        }
    }
  
    
}



extension TVViewController: TVCollectionViewCellDelegate {
    func collectionView(collectionviewcell: TVCollectionViewCell?, index: Int, didTappedInTableViewCell: TVTableViewCell) {
        let cells = didTappedInTableViewCell.tvArray
        self.tappedCell = cells[index]
        print("You tapped the cell \(index) with title \(tappedCell.name)")
        
        performSegue(withIdentifier: "DetailsScreen", sender: self)
    }
    
}
