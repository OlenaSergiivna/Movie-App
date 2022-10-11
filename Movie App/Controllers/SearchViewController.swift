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
    
    private var previousSearchRequestsMovie: [String] = ["hulk", "malena", "house of dragon"]
    private var previousSearchRequestsTV: [String] = ["star wars", "gucci", "harry potter"]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibResultCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(nibResultCell, forCellReuseIdentifier: "SearchTableViewCell")
        
        let nibRequestCell = UINib(nibName: "PreviousRequestsTableViewCell", bundle: nil)
        searchTableView.register(nibRequestCell, forCellReuseIdentifier: "PreviousRequestsTableViewCell")

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
            if !searchResultsMovie.isEmpty {
                return searchResultsMovie.count
            } else if !previousSearchRequestsMovie.isEmpty {
                return previousSearchRequestsMovie.count
            } else {
                return 10
            }
            
        case 1:
            if !searchResultsTV.isEmpty {
                return searchResultsTV.count
            } else if !previousSearchRequestsTV.isEmpty {
                return previousSearchRequestsTV.count
            } else {
                return 10
            }
            
        default:
            print("can't count cells")
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
        case 0:
            
            if !searchResultsMovie.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureMovie(with: searchResultsMovie[indexPath.row])
                return cell
                
            } else if !previousSearchRequestsMovie.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "PreviousRequestsTableViewCell", for: indexPath) as? PreviousRequestsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureRequest(with: previousSearchRequestsMovie[indexPath.row])
                return cell
                
            } else {
                return UITableViewCell()
                
            }
            
        case 1:
            
            if !searchResultsTV.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureTV(with: searchResultsTV[indexPath.row])
                return cell
                
            } else if !previousSearchRequestsTV.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "PreviousRequestsTableViewCell", for: indexPath) as? PreviousRequestsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureRequest(with: previousSearchRequestsTV[indexPath.row])
                return cell
                
            } else {
                return UITableViewCell()
                
            }
            
        default:
            print("can't create cell")
            return UITableViewCell()
        }
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
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
       
        switch selectedIndex {
            
        case 0:
            
            if text.count > 2 {
                DataManager.shared.searchMovie(with: text, page: 1) { results in
                    self.searchResultsMovie = results

                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            }
            
        case 1:
           
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
        searchTableView.reloadData()
 
    }
    
}
