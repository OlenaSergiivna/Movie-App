//
//  DetailsService.swift
//  Movie App
//
//  Created by user on 16.10.2022.
//

import UIKit

struct PaginationService {
    
    //    static let shared = PaginationService()
    //
    //    private init() {}
    
    var pageCount = 1
    
    var displayStatus = false
    
    var totalPagesCount = 10
    
    var searchText = ""
    
//    mutating func paginate<T: Sequence>(indexPath: IndexPath, tableView: UITableView, searchController: UISearchController, searchResultsArray: inout [T]) {
//
//        guard let text = searchController.searchBar.text else { return }
//        let searchText = text.replacingOccurrences(of: " ", with: "%20")
//
//        if searchResultsArray is [MovieModel] {
//            guard indexPath.row == searchResultsArray.count - 5, totalPagesCount > pageCount else { return }
//
//            self.displayStatus = true
//            self.pageCount += 1
//
//            DataManager.shared.searchMovie(with: searchText, page: pageCount) { result in
//                searchResultsArray.append(contentsOf: result as! [T])
//
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                }
//
////                self.displayStatus = false
//        }
//
//
////        if searchResultsArray is [MovieModel] {
////
////            guard indexPath.row == searchResultsArray.count - 5, totalPagesCount > pageCount else { return }
////
////            self.displayStatus = true
////            self.pageCount += 1
////
////            DataManager.shared.searchMovie(with: searchText, page: pageCount) { result in
////                searchResultsArray.append(contentsOf: result as! T)
////
////                DispatchQueue.main.async {
////                    tableView.reloadData()
////                }
////
//////                self.displayStatus = false
////            }
//        }
//    }
    
    
    
    
    
    //        if let searchResultsArray = searchResultsArray as? [TVModel] {
    //            paginateAsTVShow()
    //        }
    
    
    //        DataManager.shared.searchMovie(with: searchText, page: pageCount) { result in
    //
    //            searchResultsArray.append(contentsOf: result)
    //
    //            DispatchQueue.main.async {
    //
    //                tableView.reloadData()
    //            }
    //            displayStatus = false
    //        }
    
    private mutating func paginateAsMovie(indexPath: IndexPath, tableView: UITableView, searchResultsArray: inout [MovieModel] ) {
        
        //        guard indexPath.row == searchResultsArray.count - 5, totalPagesCount > pageCount else {
        //            return
        //        }
        //
        //        self.displayStatus = true
        //        self.pageCount += 1
        //
        //        DataManager.shared.searchMovie(with: searchText, page: pageCount) { result in
        //            searchResultsArray.append(contentsOf: result)
        //
        //            DispatchQueue.main.async {
        //                tableView.reloadData()
        //            }
        //
        //            self.displayStatus = false
        //        }
        //
        //    }
        
    }
    private func paginateAsTVShow() {
        
    }
    
    
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
