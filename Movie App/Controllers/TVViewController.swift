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
    
    let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView()
        
        let nibMovieCell = UINib(nibName: "TVTableViewCell", bundle: nil)
        tvTableView.register(nibMovieCell, forCellReuseIdentifier: "TVTableViewCell")
        
        // MARK: - Fetch tv shows data
        
        DataManager.shared.requestTVGenres { [weak self] data, statusCode in
            
            if statusCode == 200 {
                
                Globals.tvGenres = data
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else {
                        return
                    }
                    
                    self.tvTableView.reloadData()
                    
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



extension TVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.tvGenres.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tvTableView.dequeueReusableCell(withIdentifier: "TVTableViewCell", for: indexPath) as? TVTableViewCell else {
            return UITableViewCell()
        }
        
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
