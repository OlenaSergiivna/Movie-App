//
//  SearchViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var noSearchResultsView: UIView!
    
    private var searchResultsTV: [TVModel] = []
    
    private var searchResultsMovie: [MovieModel] = []
    
    private var previousSearchRequests: [Media] = []
    
    var pageCount = 1
    
    var displayStatus = false
    
    var totalPagesCount = 10
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.layoutMargins = .zero
        searchTableView.keyboardDismissMode = .onDrag
        searchTableView.delegate = self
        
        configureUI()
        setUpNotifications()
        
        
        // MARK: - Registration nibs
        
        let nibResultCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(nibResultCell, forCellReuseIdentifier: "SearchTableViewCell")
        
        let nibRequestCell = UINib(nibName: "PreviousRequestsTableViewCell", bundle: nil)
        searchTableView.register(nibRequestCell, forCellReuseIdentifier: "PreviousRequestsTableViewCell")
        
        
        // Decode data from UserDefaults and set as previous search requests
        
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
        
        searchTableView.isUserInteractionEnabled = true
        noSearchResultsView.isHidden = true
        
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
        NetworkManager.shared.logOutAndGetBackToLoginView(self)
    }
    
    
    func setUpNotifications() {
        let mainNotificationCenter = NotificationCenter.default
        
        mainNotificationCenter.addObserver(self, selector: #selector(appWasReturnedOnForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    @objc func appWasReturnedOnForeground() {
        
        tabBarController?.tabBar.isHidden = false
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
                return 0
            }
            
        case 1:
            
            if !searchResultsTV.isEmpty {
                return searchResultsTV.count
            } else if !previousSearchRequests.isEmpty {
                return previousSearchRequests.count
            } else {
                return 0
            }
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
            
        case 0:
            if previousSearchRequests.isEmpty || !searchResultsMovie.isEmpty {
                return 0
            } else {
                return 30
            }
            
        case 1:
            if previousSearchRequests.isEmpty || !searchResultsTV.isEmpty {
                return 0
            } else {
                return 30
            }
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        headerView.backgroundColor = .black
        
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)
        
        headerLabel.text = "Resent searches"
        headerLabel.textColor = .white
        headerLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.heightAnchor.constraint(equalToConstant: 15)
             ])
        
        let clearButton = UIButton()

        headerView.addSubview(clearButton)
        
        clearButton.setTitle("Clear all", for: .normal)
        clearButton.setTitleColor(.systemPink, for: .normal)
        clearButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        clearButton.contentMode = .center
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5),
            clearButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            clearButton.heightAnchor.constraint(equalToConstant: 15)
    
             ])
        
        clearButton.addTarget(self, action: #selector(cleanSearchHistory), for: .touchUpInside)
        
        return headerView
    }
    
    
    @objc func cleanSearchHistory() {
        
        previousSearchRequests.removeAll()
        saveInUserDefaults(previousSearchRequests)
        searchTableView.reloadData()
    }
    
    
    // Encode data to bytes type (Data) to save in UserDefaults
    
    func saveInUserDefaults(_ data: [Media] ) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "searchResults")
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
                let cell = UITableViewCell()
                cell.backgroundColor = .black
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        let isWidthBigger = {
            return UIScreen.main.bounds.width > UIScreen.main.bounds.height
        }
        
        switch selectedIndex {
            
        case 0:
            guard !searchResultsMovie.isEmpty else {
                return UITableView.automaticDimension
            }
            
            if isWidthBigger() {
                return view.frame.height / 2.5
            } else {
                return view.frame.height / 6
            }
            
            
        case 1:
            guard !searchResultsTV.isEmpty else {
                return UITableView.automaticDimension
            }
            
            if isWidthBigger() {
                return view.frame.height / 2.5
            } else {
                return view.frame.height / 6
            }
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                
                saveInUserDefaults(previousSearchRequests)
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
                
                saveInUserDefaults(previousSearchRequests)
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
                
                if results.isEmpty {
                    self.noSearchResultsView.isHidden = false
                    self.searchTableView.isUserInteractionEnabled = false
                } else {
                    self.noSearchResultsView.isHidden = true
                    self.searchTableView.isUserInteractionEnabled = true
                }
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
                
                if results.isEmpty {
                    self.noSearchResultsView.isHidden = false
                    self.searchTableView.isUserInteractionEnabled = false
                } else {
                    self.noSearchResultsView.isHidden = true
                    self.searchTableView.isUserInteractionEnabled = true
                }
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
        
        searchTableView.isUserInteractionEnabled = true
        noSearchResultsView.isHidden = true
        
        searchResultsMovie = []
        searchResultsTV = []
        pageCount = 1
        searchController.searchBar.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
            
        case 0:
            guard searchResultsMovie.isEmpty else {
                return UISwipeActionsConfiguration()
            }
            
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] action, view, completion in
                action.backgroundColor = .systemPink
                view.backgroundColor = .orange
                guard let self else { return }
                
                self.previousSearchRequests.remove(at: indexPath.row)
                self.saveInUserDefaults(self.previousSearchRequests)
                self.searchTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
            
        case 1:
            guard searchResultsTV.isEmpty else {
                return UISwipeActionsConfiguration()
            }
            
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] action, view, completion in
                action.backgroundColor = .systemPink
                view.backgroundColor = .orange
                guard let self else { return }
                
                self.previousSearchRequests.remove(at: indexPath.row)
                self.saveInUserDefaults(self.previousSearchRequests)
                self.searchTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
            
        default:
            return UISwipeActionsConfiguration()
        }
    }
}
