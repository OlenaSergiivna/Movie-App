//
//  FavouritesViewControllerViewModel.swift
//  Movie App
//
//  Created by user on 05.10.2022.
//

import Foundation
//import RxSwift
//import RxCocoa


class FavouritesViewControllerViewModel {
    
    //var someMovies = BehaviorRelay<[MovieModel]>(value: [])
    
    //var bag = DisposeBag()
    
    func loadFavoriteMovies() {
        
        RepositoryService.shared.movieFavoritesCashing { [weak self] favorites in
            guard let self else { return }
            
            //self.someMovies.accept(favorites)
            
//            self.someMovies.onNext(favorites)
//            self.someMovies.onCompleted()
        }
    }
}
