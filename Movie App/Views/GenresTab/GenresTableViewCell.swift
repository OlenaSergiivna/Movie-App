//
//  GenresTableViewCell.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.genresCollectionView.dataSource = self
        self.genresCollectionView.delegate = self
        
        
        self.genresCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension GenresTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.movieNameLabel.text = "House of Dragon"
//        cell.layer.masksToBounds = true
//        cell.layer.cornerRadius = 20
        
        cell.movieImage.image = UIImage(named: "house")
        cell.movieImage.layer.masksToBounds = true
        cell.movieImage.layer.cornerRadius = 20
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
}

