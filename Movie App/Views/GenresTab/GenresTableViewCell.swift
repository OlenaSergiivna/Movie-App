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

extension GenresTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.movieNameLabel.text = "House of Dragon"
        cell.movieImage.image = UIImage(named: "house")
        return cell
    }
    
}
