//
//  SearchViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    private var searchResultsTV: [TVModel] = []
    private var searchResultsMovie: [MovieModel] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibFavouritesCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(nibFavouritesCell, forCellReuseIdentifier: "SearchTableViewCell")
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Movies","TV Shows"]
        definesPresentationContext = true
        
        
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


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        
        switch selectedIndex {
        case 0:
            return !searchResultsMovie.isEmpty ? searchResultsMovie.count : 0
        case 1:
            return !searchResultsTV.isEmpty ? searchResultsTV.count : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
        case 0:

            if !searchResultsMovie.isEmpty {
                cell.configureMovie(with: searchResultsMovie[indexPath.row])
                
                return cell
            }
        case 1:
            
            if !searchResultsTV.isEmpty {
                cell.configureTV(with: searchResultsTV[indexPath.row])
                
                return cell
            }
            
        default:
            var content = cell.defaultContentConfiguration()
            content.text = "No search results"
            cell.contentConfiguration = content
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print("text = \(text)")
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        print("selected index = \(selectedIndex)")
        switch selectedIndex {
        case 0:
            print("update search results: movie")
            if text.count > 2 {
                DataManager.shared.searchMovie(with: text, page: 1) { results in
                    self.searchResultsMovie = results
                    
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            }
        case 1:
            print("update search results: tv")
            if text.count > 2 {
                DataManager.shared.searchTV(with: text, page: 1) { results in
                    self.searchResultsTV = results
                    
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            }
        default:
            print("Can't find segmented control...")
        }
        
    }
}



extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
        
    }
    
}
