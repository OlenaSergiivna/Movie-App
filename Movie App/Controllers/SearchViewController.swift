//
//  SearchViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

// rearch requests saving on scroll + on movie tap

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    private var searchResultsTV: [TVModel] = []
    private var searchResultsMovie: [MovieModel] = [] {
        didSet {
            print("array count: \(searchResultsMovie.count)")
        }
    }
    
    private var previousSearchRequests: [String] = []
//    {
//        didSet {
//            print("request array: \(previousSearchRequests)")
//        }
//    }
    
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
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.keyboardDismissMode = .onDrag
        
        // MARK: - Setting refresh control programatically
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updatateTableView), for: .valueChanged)
        searchTableView.refreshControl = refreshControl
        refreshControl.tintColor = .systemTeal
        refreshControl.attributedTitle = NSAttributedString("Refreshing")
        refreshControl.sizeToFit()
        
       //UserDefaults.standard.removeObject(forKey: "requests")
        
        // MARK: - Registration nibs
        
        let nibResultCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(nibResultCell, forCellReuseIdentifier: "SearchTableViewCell")
        
        let nibRequestCell = UINib(nibName: "PreviousRequestsTableViewCell", bundle: nil)
        searchTableView.register(nibRequestCell, forCellReuseIdentifier: "PreviousRequestsTableViewCell")
        
        // MARK: - Setting search control programatically
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Movies","TV Shows"]
        definesPresentationContext = true
        
        // MARK: - Setting search textfield
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .never
        
        
        // MARK: - Get data from UserDefaults
        if let value = UserDefaults.standard.stringArray(forKey: "requests") {
         previousSearchRequests = value
        }
        
    }
    
    @objc func updatateTableView(refreshControl: UIRefreshControl) {
        pageCount = 1
        updateSearchResults(for: searchController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            refreshControl.endRefreshing()
        }
        
    }
        
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
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
                return UITableViewCell()
                
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
                print("previous search requests: \(previousSearchRequests[indexPath.row])")
                cell.configureRequest(with: previousSearchRequests[indexPath.row])
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // response: what if the is no movies/tv shows on request?
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        let cell = searchTableView.cellForRow(at: indexPath)
        
        switch selectedIndex {
            
        case 0:
            
            if cell is PreviousRequestsTableViewCell {
                searchController.searchBar.endEditing(true)
                searchController.searchBar.resignFirstResponder()
                displayStatus = true
                let text = previousSearchRequests[indexPath.row]
                let searchText = text.replacingOccurrences(of: " ", with: "%20")
                searchController.searchBar.text = text
                
                DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] results in
                    guard let self else { return }
                    
                    self.searchResultsMovie = results
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.reloadData()
                    }
                    self.displayStatus = false
                }
                
            } else if cell is SearchTableViewCell {
                print("movie cell tapped")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
                    
                    destinationViewController.loadViewIfNeeded()
                    destinationViewController.configure(with: searchResultsMovie[indexPath.row])
                    navigationController?.present(destinationViewController, animated: true)
          
                }
            } else {
                print("tapped empty cell")
            }
            
        case 1:
            
            if cell is PreviousRequestsTableViewCell {
                searchController.searchBar.resignFirstResponder()
                displayStatus = true
                
                let text = previousSearchRequests[indexPath.row]
                let searchText = text.replacingOccurrences(of: " ", with: "%20")
                searchController.searchBar.text = text
                
                
                DataManager.shared.searchTV(with: searchText, page: 1) { [weak self] results in
                    guard let self else { return }
                    
                    self.searchResultsTV = results
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.reloadData()
                    }
                    
                    self.displayStatus = false
                }
            } else if cell is SearchTableViewCell {
                print("tv cell tapped")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
                    
                    destinationViewController.loadViewIfNeeded()
                    destinationViewController.configure(with: searchResultsTV[indexPath.row])
                    navigationController?.present(destinationViewController, animated: true)
                }
            } else {
                print("tapped empty cell")
            }
            
        default:
            return
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        
        switch selectedIndex {
        case 0:
            
            if ((indexPath.row == searchResultsMovie.count - 5) && totalPagesCount > pageCount) {
                
                displayStatus = true
                pageCount += 1
                
//                DispatchQueue.main.async {
//                    self.searchTableView.reloadSections(IndexSet(integer: 1), with: .none)
//
//                }
                
                DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] result in
                    
                    guard let self else { return }
                    
                    self.searchResultsMovie.append(contentsOf: result)
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.reloadData()
                    }
                    self.displayStatus = false
                }
            }
            
        case 1:
            
            if ((indexPath.row == searchResultsTV.count - 5) && totalPagesCount > pageCount) {
                
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
            }
            
        default:
            return
        }
    }
}


extension SearchViewController: UISearchResultsUpdating {
    // response: what if the is no results on request?
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {
            return
        }
        let searchText = text.replacingOccurrences(of: " ", with: "%20")

        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
            
        case 0:
            
            if text.count > 2 && displayStatus == false {
                displayStatus = true
                DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] results in
                    
                    guard let self else { return }
                    
                    self.searchResultsMovie = results
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.reloadData()
                    }
                    
                    self.displayStatus = false
                }
            }
            
        case 1:
            
            if text.count > 2 && displayStatus == false {
                displayStatus = true
                DataManager.shared.searchTV(with: searchText, page: 1) { [weak self] results in
                    guard let self else { return }
                    
                    self.searchResultsTV = results
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.reloadData()
                    }
                    
                    self.displayStatus = false
                }
            }
            
        default:
            print("Can't find segmented control...")
        }
    }
    
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         
            guard let text = searchController.searchBar.text  else {
                return
            }
        
        let preSearchText = text.trimmingCharacters(in: .whitespaces)
        let searchText = preSearchText.trimmingCharacters(in: .punctuationCharacters)
        
        if !searchText.isEmpty && !previousSearchRequests.contains(where: { ($0 == searchText)}) {
            
            previousSearchRequests.insert(searchText.capitalized, at: 0)
                print("inserted: \(searchText)")
            }
            
            if previousSearchRequests.count > 10 {
                previousSearchRequests.removeLast()
                print("removed last ")
            }
            
            UserDefaults.standard.set(previousSearchRequests, forKey: "requests")
            print("request saved in UD")
    }
}
    
    extension SearchViewController: UISearchBarDelegate {
        
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            pageCount = 1
            updateSearchResults(for: searchController)
            searchTableView.reloadData()
        }
        
        
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            let selectedIndex = searchController.searchBar.selectedScopeButtonIndex

            switch selectedIndex {

            case 0:
                searchResultsMovie = []
                pageCount = 1
                searchController.searchBar.resignFirstResponder()

            case 1:
                searchResultsTV = []
                pageCount = 1
                searchController.searchBar.resignFirstResponder()


            default:
                return

            }

            DispatchQueue.main.async {
                
                self.searchTableView.reloadData()
            }
        }
        
        
    }
