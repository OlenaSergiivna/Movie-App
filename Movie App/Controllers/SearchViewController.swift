//
//  SearchViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Swinject

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var noSearchResultsView: UIView!
    
    @Injected private var detailsService: DetailsServiceProtocol
    
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
        searchTableView.sectionHeaderTopPadding = 0
        
        configureUI()
        
        
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
        
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
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
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
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
        searchController.searchBar.searchTextField.clearButtonMode = .always
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        NetworkManager.shared.logOutAndGetBackToLoginView(self)
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
        case 0:
            
            if !searchResultsMovie.isEmpty {
                return searchResultsMovie.count
            } else {
                return previousSearchRequests.count
            }
            
        case 1:
            
            if !searchResultsTV.isEmpty {
                return searchResultsTV.count
            } else {
                return previousSearchRequests.count
            }
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if previousSearchRequests.isEmpty || !searchResultsMovie.isEmpty || !searchResultsTV.isEmpty{
            return 0
        } else {
            return 30
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
        
        clearButton.addTarget(self, action: #selector(clearSearchHistory), for: .touchUpInside)
        
        return headerView
    }
    
    
    @objc func clearSearchHistory() {
        
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
                
            } else {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "PreviousRequestsTableViewCell", for: indexPath) as? PreviousRequestsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureRequest(with: previousSearchRequests[indexPath.row])
                return cell
            }
            
        case 1:
            
            if !searchResultsTV.isEmpty {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureTV(with: searchResultsTV[indexPath.row])
                return cell
                
            } else {
                
                guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "PreviousRequestsTableViewCell", for: indexPath) as? PreviousRequestsTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configureRequest(with: previousSearchRequests[indexPath.row])
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let isWidthBigger = {
            return UIScreen.main.bounds.width > UIScreen.main.bounds.height
        }
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
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
        
        let cell = searchTableView.cellForRow(at: indexPath)
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
            
        case 0:
            
            if cell is PreviousRequestsTableViewCell {
                
               detailsService.openDetailsScreen(with: previousSearchRequests[indexPath.row], viewController: self)
                
                
            } else if cell is SearchTableViewCell {
                
                detailsService.openDetailsScreen(with: searchResultsMovie[indexPath.row], viewController: self)
                
                if let containingIndex = previousSearchRequests.firstIndex(of: .movie(searchResultsMovie[indexPath.row])) {
                    
                    previousSearchRequests.remove(at: containingIndex)
                }
                
                previousSearchRequests.insert(.movie(searchResultsMovie[indexPath.row]), at: 0)
                
                if previousSearchRequests.count > 10 {
                    previousSearchRequests.removeLast()
                }
                
                saveInUserDefaults(previousSearchRequests)
            }
            
        case 1:
            
            if cell is PreviousRequestsTableViewCell {
                
                detailsService.openDetailsScreen(with: previousSearchRequests[indexPath.row], viewController: self)
                
                
            } else if cell is SearchTableViewCell {
                
                detailsService.openDetailsScreen(with: searchResultsTV[indexPath.row], viewController: self)
                
                if let containingIndex = previousSearchRequests.firstIndex(of: .tvShow(searchResultsTV[indexPath.row])) {
                    
                    previousSearchRequests.remove(at: containingIndex)
                }
                
                previousSearchRequests.insert(.tvShow(searchResultsTV[indexPath.row]), at: 0)
                
                if previousSearchRequests.count > 10 {
                    previousSearchRequests.removeLast()
                }
                
                saveInUserDefaults(previousSearchRequests)
            }
            
        default:
            return
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard cell is SearchTableViewCell, let text = searchController.searchBar.text else { return }
        
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch selectedIndex {
            
        case 0:
            
            guard indexPath.row == searchResultsMovie.count - 5, totalPagesCount > pageCount, displayStatus == false else { return }
            
            displayStatus = true
            pageCount += 1
            
            DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] result in
                
                guard let self else { return }
                
                switch result {
                    
                case .success(let results):
                    self.displayStatus = false
                    
                    // replaced reloadData with insertRows to remove flickering
                    let startIndex = self.searchResultsMovie.count
                    self.searchResultsMovie.append(contentsOf: results.movies)
                    let endIndex = self.searchResultsMovie.count
                    
                    let indexPathsToReload = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.beginUpdates()
                        self.searchTableView.insertRows(at: indexPathsToReload, with: .automatic)
                        self.searchTableView.endUpdates()
                    }
                    
                case .failure(let error):
                    self.displayStatus = false
                    self.pageCount -= 1
                    print("Error when try to search more movies: \(error.localizedDescription)")
                }
            }
            
        case 1:
            
            guard indexPath.row == searchResultsTV.count - 5, totalPagesCount > pageCount, displayStatus == false else {
                return
            }
            
            displayStatus = true
            pageCount += 1
            
            DataManager.shared.searchTV(with: searchText, page: pageCount) { [weak self] result in
                guard let self else { return }
                
                switch result {
                    
                case .success(let results):
                    self.displayStatus = false
                    
                    // replaced reloadData with insertRows to remove flickering
                    let startIndex = self.searchResultsTV.count
                    self.searchResultsTV.append(contentsOf: results.tvShows)
                    let endIndex = self.searchResultsTV.count
                    
                    let indexPathsToReload = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    
                    DispatchQueue.main.async {
                        
                        self.searchTableView.beginUpdates()
                        self.searchTableView.insertRows(at: indexPathsToReload, with: .automatic)
                        self.searchTableView.endUpdates()
                    }
                    
                case .failure(let error):
                    self.displayStatus = false
                    self.pageCount -= 1
                    print("Error when try to search more tv shows: \(error.localizedDescription)")
                }
            }
            
        default:
            return
        }
    }
}


extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        guard let text = searchController.searchBar.text else { return }
        
        let textWithoutBlankSpaces = text.replacingOccurrences(of: " ", with: "")
        
        guard textWithoutBlankSpaces.count > 0 else {
            
            switch selectedIndex {
            case 0:
                searchResultsMovie = []
            case 1:
                searchResultsTV = []
            default:
                return
            }
            searchTableView.reloadData()
            return
        }
        
        guard displayStatus == false else { return }
        
        // check to start searching from 1st page for every new text
        if pageCount > 1  { pageCount = 1 }
        
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        
        
        switch selectedIndex {
            
        case 0:
            
            displayStatus = true
            
            DataManager.shared.searchMovie(with: searchText, page: pageCount) { [weak self] result in
                guard let self else { return }
                
                switch result {
                    
                case .success(let results):
                    self.displayStatus = false
                    self.totalPagesCount = results.totalPages
                    
                    self.searchResultsMovie = results.movies
                    
                    
                    if results.movies.isEmpty {
                        self.noSearchResultsView.isHidden = false
                        self.searchTableView.isUserInteractionEnabled = false
                        
                    } else {
                        self.noSearchResultsView.isHidden = true
                        self.searchTableView.isUserInteractionEnabled = true
                        
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                            self.searchTableView.layoutIfNeeded()
                            
                            self.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        }
                    }
                    
                case .failure(let error):
                    self.displayStatus = false
                    print("Error while searching movies: \(error.localizedDescription)")
                }
            }
            
        case 1:
            
            displayStatus = true
            
            DataManager.shared.searchTV(with: searchText, page: pageCount) { [weak self] result in
                guard let self else { return }
                
                switch result {
                    
                case .success(let results):
                    self.displayStatus = false
                    self.totalPagesCount = results.totalPages
                    
                    self.searchResultsTV = results.tvShows
                    
                    
                    if results.tvShows.isEmpty {
                        self.noSearchResultsView.isHidden = false
                        self.searchTableView.isUserInteractionEnabled = false
                        
                    } else {
                        self.noSearchResultsView.isHidden = true
                        self.searchTableView.isUserInteractionEnabled = true
                        
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                            self.searchTableView.layoutIfNeeded()
                            
                            self.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        }
                    }
                    
                case .failure(let error):
                    self.displayStatus = false
                    print("Error while searching tv shows: \(error.localizedDescription)")
                }
            }
            
        default:
            return
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        DataManager.shared.cancelAllTasks()
        displayStatus = false
        
        if selectedScope == 0 {
            searchResultsMovie = []
            searchController.searchBar.placeholder = "Movie"
        } else if selectedScope == 1 {
            searchResultsTV = []
            searchController.searchBar.placeholder = "TV Shows"
        }
        
        pageCount = 1
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            self.searchTableView.layoutIfNeeded()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        DataManager.shared.cancelAllTasks()
        
        searchResultsMovie = []
        searchResultsTV = []
        pageCount = 1
        
        searchTableView.isUserInteractionEnabled = true
        noSearchResultsView.isHidden = true
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            self.searchTableView.layoutIfNeeded()
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
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        DataManager.shared.cancelAllTasks()
        
        searchResultsMovie = []
        searchResultsTV = []
        pageCount = 1
        
        searchTableView.isUserInteractionEnabled = true
        noSearchResultsView.isHidden = true
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            self.searchTableView.layoutIfNeeded()
        }
        
        return true
    }
}
