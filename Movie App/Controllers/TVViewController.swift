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
        
        loadContent()
        
        let nibMovieCell = UINib(nibName: "TVTableViewCell", bundle: nil)
        tvTableView.register(nibMovieCell, forCellReuseIdentifier: "TVTableViewCell")
        
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            
            guard let self else { return }
            
            guard result == true else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
            self.present(viewController, animated: true)
        }
    }
    
    
    func loadContent() {
        
        let loadingVC = LoadingViewController()
        add(loadingVC)
        
        DataManager.shared.requestTVGenres { data, statusCode in
            
            guard statusCode == 200 else { return }
            
            Globals.tvGenres = data
            
            DispatchQueue.main.async {
                self.tvTableView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                loadingVC.remove()
            }
        }
    }
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }
    
    
    func configureUI() {
        
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
}


extension TVViewController: TVCollectionViewCellDelegate {
    func collectionView(collectionviewcell: TVCollectionViewCell?, index: Int, didTappedInTableViewCell: TVTableViewCell) {
        
        let cells = didTappedInTableViewCell.tvArray
        tappedCell = cells[index]
        
        DetailsService.shared.openDetailsScreen(with: tappedCell, navigationController: navigationController)
    }
}
