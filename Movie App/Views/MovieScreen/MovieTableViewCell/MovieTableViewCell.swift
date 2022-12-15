//
//  MovieTableViewCell.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: MovieCollectionViewCell?, index: Int, didTappedInTableViewCell: MovieTableViewCell)
}

class MovieTableViewCell: UITableViewCell {
    
    weak var cellDelegate: MovieCollectionViewCellDelegate?
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var moviesArray: [MovieModel] = [] {
        didSet {
            
            let nibTVCollectionViewCell = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
            moviesCollectionView.register(nibTVCollectionViewCell, forCellWithReuseIdentifier: "MovieCollectionViewCell")

            moviesCollectionView.dataSource = self
            moviesCollectionView.delegate = self

            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
    override func prepareForReuse() {
        
        moviesCollectionView.dataSource = nil
        moviesCollectionView.delegate = nil
        moviesCollectionView.reloadData()
    }
}


extension MovieTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard moviesArray.isEmpty else {
            return 4
        }
        return moviesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: moviesArray, indexPath: indexPath)
        return cell
    }
}


extension MovieTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = moviesCollectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else { return }
        
           cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
    }


extension MovieTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
}
