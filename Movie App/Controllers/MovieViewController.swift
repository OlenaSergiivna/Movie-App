//
//  GenresViewController.swift
//  Movie App
//
//  Created by user on 26.09.2022.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var tappedCell: MovieModel!

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
     
        let nibMovieCell = UINib(nibName: "MovieTableViewCell", bundle: nil)
        movieTableView.register(nibMovieCell, forCellReuseIdentifier: "MovieTableViewCell")
        
        // MARK: - Fetch movie data
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            if statusCode == 200 {
                
                Globals.movieGenres = data
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else {
                        return
                    }
                    
                    self.movieTableView.reloadData()
                    
                    self.removeSpinnerView()
                    
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



extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.movieGenres.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        // Set cell's delegate
        
        cell.cellDelegate = self
        
        cell.genreLabel.text = Globals.movieGenres[indexPath.row].name
        
        
        DispatchQueue.main.async {
            DataManager.shared.requestMoviesByGenre(genre: cell.genreLabel.text!, page: 1) { movies in
                
                cell.moviesArray = movies
            }
        }

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailsviewcontrollerseg" {
//            let DestViewController = segue.destination as! DetailsViewController
//            DestViewController.backgroundColor = tappedCell.color
//            DestViewController.backgroundColorName = tappedCell.name
//        }
//    }
    
}

extension MovieViewController: CollectionViewCellDelegate {
    
    func collectionView(collectionviewcell: MovieCollectionViewCell?, index: Int, didTappedInTableViewCell: MovieTableViewCell) {
        let cells = didTappedInTableViewCell.moviesArray
        self.tappedCell = cells[index]
        print("You tapped the cell \(index) with title \(tappedCell.title ?? "0")")
            // You can also do changes to the cell you tapped using the 'collectionviewcell'
        
    }
}
