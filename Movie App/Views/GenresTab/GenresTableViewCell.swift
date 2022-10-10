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
    
    var moviesArray: [MovieModel] = [] { 
        didSet {
            
            self.genresCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
            
             genresCollectionView.dataSource = self
             genresCollectionView.delegate = self
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.genresCollectionView.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.genresCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
        
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
        
        cell.configure(with: moviesArray, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
}

