//
//  GenresTableViewCell.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var moviesArray: [Movie] = [] { 
        didSet {
            let nibCollectionCell = UINib(nibName: "GenreCollectionViewCell", bundle: nil)
            self.genresCollectionView.register(nibCollectionCell, forCellWithReuseIdentifier: "GenreCollectionViewCell")
            
             genresCollectionView.dataSource = self
             genresCollectionView.delegate = self
            
            DispatchQueue.main.async {
                self.genresCollectionView.reloadData()
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Array: \(moviesArray.count)")
        self.genresCollectionView.reloadData()
        
    }
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {

        genresCollectionView.dataSource = nil
        genresCollectionView.delegate = nil
        genresCollectionView.reloadData()
        
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
    }
    
    
}

extension GenresTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !moviesArray.isEmpty {
            return moviesArray.count
        } else {
            return 4
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        print("Array2: \(moviesArray.count)")
        
        cell.configure(with: moviesArray, indexPath: indexPath)
        
        print("CV indexPath.row: \(indexPath.row) - \(cell.movieNameLabel.text!)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
}

