//
//  GenresViewController.swift
//  Movie App
//
//  Created by user on 26.09.2022.
//

import UIKit

class MovieViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var tappedCell: MovieModel!
    
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
        
        let nibMovieCell = UINib(nibName: "MovieTableViewCell", bundle: nil)
        movieTableView.register(nibMovieCell, forCellReuseIdentifier: "MovieTableViewCell")
        
        configureUI()
        loadContent()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOutAndGetBackToLoginView(self)
    }
    
    
    func loadContent() {
        
        let loadingVC = LoadingViewController()
        add(loadingVC)
        
        DataManager.shared.requestMovieGenres { data, statusCode in
            
            guard statusCode == 200 else { return }
            Globals.movieGenres = data
            
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                loadingVC.remove()
            }
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
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
    
}



extension MovieViewController: MovieCollectionViewCellDelegate {
    
    func collectionView(collectionviewcell: MovieCollectionViewCell?, index: Int, didTappedInTableViewCell: MovieTableViewCell) {
        let cells = didTappedInTableViewCell.moviesArray
        self.tappedCell = cells[index]
        
        DetailsService.shared.openDetailsScreen(with: tappedCell, navigationController: navigationController)
    }
}
