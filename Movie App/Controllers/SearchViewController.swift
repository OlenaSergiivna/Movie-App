//
//  SearchViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

// rearch requests saving on scroll + on movie tap
//make search requests table view editable

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    private var searchResultsTV: [TVModel] = []
    
    private var searchResultsMovie: [MovieModel] = []
    
    private var previousSearchRequests: [Media] = [] {
        didSet {
            print("previousSearchRequests: \(previousSearchRequests.count)")
        }
    }
    
    var pageCount = 1

    var displayStatus = false
    
    var totalPagesCount = 10
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.layoutMargins = .zero
        configureUI()
        searchTableView.keyboardDismissMode = .onDrag
        
        
        //UserDefaults.standard.removeObject(forKey: "searchResults")
        
        // MARK: - Registration nibs
        
        let nibResultCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(nibResultCell, forCellReuseIdentifier: "SearchTableViewCell")
        
        let nibRequestCell = UINib(nibName: "PreviousRequestsTableViewCell", bundle: nil)
        searchTableView.register(nibRequestCell, forCellReuseIdentifier: "PreviousRequestsTableViewCell")
        
        
        // MARK: - Get data from UserDefaults
        
        //print(UserDefaults.standard.object(forKey: "searchResults"))
        if let movie = UserDefaults.standard.object(forKey: "searchResults") as? Data {
            let decoder = JSONDecoder()
            do {
                
                if let movieDecoded = try? decoder.decode([Media].self, from: movie ) {
                    previousSearchRequests = movieDecoded
                }
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    
    @objc func updatateTableView(refreshControl: UIRefreshControl) {
        pageCount = 1
        updateSearchResults(for: searchController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            refreshControl.endRefreshing()
        }
        
    }
    
    
    func configureUI(){
        view.backgroundColor = .black
        
        configureNavBar()
        configureRefreshControl()
        configureSearchController()
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
    
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updatateTableView), for: .valueChanged)
        searchTableView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString("Refreshing")
        refreshControl.sizeToFit()
    }
    
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Movies"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Movies","TV Shows"]
        definesPresentationContext = true
        
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .unlessEditing
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            guard let self else { return }
            
            guard result == true else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
            self.present(viewController, animated: true)
        }
    }
    
    
    
    func deleteAll(from array: inout [String], key: String, completion: () -> Void) {
        
        array.removeAll()
        UserDefaults.standard.set(array, forKey: key)
        completion()
        
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
        case 0:
            
            if !searchResultsMovie.isEmpty {
                return searchResultsMovie.count
            } else if !previousSearchRequests.isEmpty {
                return previousSearchRequests.count
            } else {
                return 10
            }
            
        case 1:
            
            if !searchResultsTV.isEmpty {
                return searchResultsTV.count
            } else if !previousSearchRequests.isEmpty {
                return previousSearchRequests.count
            } else {
                return 10
            }
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UITableViewHeaderFooterView()
        
        var contentConfig = UIListContentConfiguration.plainHeader()
        contentConfig.text = "Resent searches"
        contentConfig.textProperties.color = .white
        contentConfig.textProperties.font = .systemFont(ofSize: 16, weight: .bold)
        
        var backConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backConfig.backgroundColor = .clear
        
        headerView.contentConfiguration = contentConfig
        headerView.backgroundConfiguration = backConfig
        
        searchTableView.layoutMargins.left = 16
        
        return headerView
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
                
            } else if !previousSearchRequests.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "PreviousRequestsTableViewCell", for: indexPath) as? PreviousRequestsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureRequest(with: previousSearchRequests[indexPath.row])
                return cell
                
            } else {
                let cell = UITableViewCell()
                cell.backgroundColor = .black
                return cell
                
            }
            
        case 1:
            
            if !searchResultsTV.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureTV(with: searchResultsTV[indexPath.row])
                return cell
                
            } else if !previousSearchRequests.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "PreviousRequestsTableViewCell", for: indexPath) as? PreviousRequestsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureRequest(with: previousSearchRequests[indexPath.row])
               
                return cell
                
            } else {
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !searchResultsMovie.isEmpty || !searchResultsTV.isEmpty {

            return view.frame.height / 6
        }
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // response: what if the is no movies/tv shows on request?
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        let cell = searchTableView.cellForRow(at: indexPath)
        
        switch selectedIndex {
            
        case 0:
            
            if cell is PreviousRequestsTableViewCell {
                searchController.searchBar.endEditing(true)
                searchController.searchBar.resignFirstResponder()
                
                DetailsService.shared.openDetailsScreen(with: previousSearchRequests[indexPath.row], navigationController: navigationController)
                
                
            } else if cell is SearchTableViewCell {
                print("movie cell tapped")
                
                DetailsService.shared.openDetailsScreen(with: searchResultsMovie[indexPath.row], navigationController: navigationController)
                
                guard !previousSearchRequests.contains(.movie(searchResultsMovie[indexPath.row])) else {return}
                
                previousSearchRequests.insert(.movie(searchResultsMovie[indexPath.row]), at: 0)
                
                if previousSearchRequests.count > 10 {
                    previousSearchRequests.removeLast()
                    print("removed last ")
                }
                
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(previousSearchRequests) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "searchResults")
                }
                
                print("requests updated in UD")
                
                
            }
            
        case 1:
            
            if cell is PreviousRequestsTableViewCell {
                searchController.searchBar.resignFirstResponder()
                
                DetailsService.shared.openDetailsScreen(with: previousSearchRequests[indexPath.row], navigationController: navigationController)
                
                
            } else if cell is SearchTableViewCell {
                print("tv cell tapped")
                
                DetailsService.shared.openDetailsScreen(with: searchResultsTV[indexPath.row], navigationController: navigationController)
                
                guard !previousSearchRequests.contains(.tvShow(searchResultsTV[indexPath.row])) else {return}
                
                previousSearchRequests.insert(.tvShow(searchResultsTV[indexPath.row]), at: 0)
                
                if previousSearchRequests.count > 10 {
                    previousSearchRequests.removeLast()
                    print("removed last ")
                }
                
                
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(previousSearchRequests) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "searchResults")
                }
                
                print("requests updated in UD")
            }
            
        default:
            return
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        guard let text = searchController.searchBar.text else { return }
        
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        
        switch selectedIndex {
            
        case 0:
            
            guard indexPath.row == searchResultsMovie.count - 5, totalPagesCount > pageCount else {
                return
            }
            
            displayStatus = true
            pageCount += 1
            
            DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] result in
                
                guard let self else { return }
                
                self.searchResultsMovie.append(contentsOf: result)
                
                DispatchQueue.main.async {
                    
                    self.searchTableView.reloadData()
                }
                self.displayStatus = false
            }
            
        case 1:
            
            guard indexPath.row == searchResultsTV.count - 5, totalPagesCount > pageCount else {
                return
            }
            
            displayStatus = true
            pageCount += 1
            
            DataManager.shared.searchTV(with: searchText, page: pageCount) { [weak self] result in
                guard let self else { return }
                
                self.searchResultsTV.append(contentsOf: result)
                
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
                
                self.displayStatus = false
                
            }
            
        default:
            return
        }
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    // response: what if the is no results on request?
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        guard text.count > 2, displayStatus == false else { return }
        
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
            
        case 0:
            
            displayStatus = true
            
            DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] results in
                guard let self else { return }
                
                self.searchResultsMovie = results
                
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
                
                self.displayStatus = false
            }
            
        case 1:
            
            displayStatus = true
            
            DataManager.shared.searchTV(with: searchText, page: pageCount) { [weak self] results in
                guard let self else { return }
                
                self.searchResultsTV = results
                
                DispatchQueue.main.async {
                    
                    self.searchTableView.reloadData()
                }
                
                self.displayStatus = false
            }
            
        default:
            return
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchController.searchBar.text else { return }
        
        if !text.isEmpty {
            searchController.searchBar.resignFirstResponder()
        }
        
        if selectedScope == 0 {
            searchController.searchBar.placeholder = "Movie"
        } else if selectedScope == 1 {
            searchController.searchBar.placeholder = "TV Shows"
        }
        
        pageCount = 1
        updateSearchResults(for: searchController)
        searchTableView.reloadData()
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchResultsMovie = []
        searchResultsTV = []
        pageCount = 1
        searchController.searchBar.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
    
}
