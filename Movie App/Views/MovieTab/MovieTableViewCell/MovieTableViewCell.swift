//
//  MovieTableViewCell.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher

protocol MovieCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: MovieCollectionViewCell?, index: Int, didTappedInTableViewCell: MovieTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}


class MovieTableViewCell: UITableViewCell {
    
    deinit {
        print("!!! Deinit: \(self)") 
      }
    
    
    weak var cellDelegate: MovieCollectionViewCellDelegate?
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var moviesArray: [MovieModel] = [] {
        didSet {
            
            moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
            
            moviesCollectionView.dataSource = self
            moviesCollectionView.delegate = self
            
            DispatchQueue.main.async {
                
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
    }
    
    
    override func prepareForReuse() {
        
        moviesCollectionView.dataSource = nil
        moviesCollectionView.delegate = nil
        moviesCollectionView.reloadData()
        
        //        moviesCollectionView.dataSource = self
        //        moviesCollectionView.delegate = self
    }
    
    
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !moviesArray.isEmpty {
            return moviesArray.count
        } else {
            return 4
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: moviesArray, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = moviesCollectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
           cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
        
    }
    
}

