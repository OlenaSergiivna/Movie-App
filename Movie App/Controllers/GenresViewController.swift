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

    let child = SpinnerViewController()
    
    var pageCount = 1 {
        didSet {
            print("page count: \(pageCount)")
        }
    }
    
    var displayStatus = false {
        didSet {
            print("display status: \(displayStatus)")
        }
    }
    
    var totalPagesCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView()
     
        //add condition: if request is success -> if second request is success -> ... -> reload data and remove spinner
        
        let nibMovieCell = UINib(nibName: "GenresTableViewCell", bundle: nil)
        genresTableView.register(nibMovieCell, forCellReuseIdentifier: "GenresTableViewCell")
        
        // MARK: - Fetch data
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.genres.append(contentsOf: data)
                
                DataManager.shared.requestTVGenres { [weak self] data, statusCode in
                
                    if statusCode == 200 {
                        
                        Globals.genres.append(contentsOf: data)

                        DispatchQueue.main.async { [weak self] in
                            guard let self else {
                                return
                            }
                            
                            self.genresTableView.reloadData()
                            
                            self.removeSpinnerView()
                            
                        }
                    }
                    
                }
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
    
    
    func createSpinnerView() {

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

    }
    
    func removeSpinnerView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self else {
                return
            }
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
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
//
//        if indexPath.row == 0 {
//            removeSpinnerView()
//        }

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
    }
    
  
    
}
