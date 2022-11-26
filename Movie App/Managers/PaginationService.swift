//
//  DetailsService.swift
//  Movie App
//
//  Created by user on 16.10.2022.
//

import UIKit

struct PaginationService {
    
    static let shared = PaginationService()
    
    private init() {}
    
    var pageCount = 1
    
    var displayStatus = false
    
    var totalPagesCount = 10
    
    var searchText = ""
    
    var searchResultsMovie: [MovieModel] = []
    
    
//    mutating func paginate(indexPath: IndexPath, searchTableView: UITableView) {
//
//        if ((indexPath.row == searchResultsMovie.count - 5) && totalPagesCount > pageCount) {
//
//            displayStatus = true
//            pageCount += 1
//
//            //                DispatchQueue.main.async {
//            //                    self.searchTableView.reloadSections(IndexSet(integer: 1), with: .none)
//            //
//            //                }
//
//            DataManager.shared.searchMovie(with: searchText, page: pageCount) { result in
//
//                searchResultsMovie.append(contentsOf: result)
//
//                DispatchQueue.main.async {
//
//                    searchTableView.reloadData()
//                }
//
//                displayStatus = false
//            }
//        }
//    }
}
