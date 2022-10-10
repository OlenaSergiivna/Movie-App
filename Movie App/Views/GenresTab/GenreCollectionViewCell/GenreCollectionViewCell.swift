//
//  GenreCollectionViewCell.swift
//  Movie App
//
//  Created by user on 28.09.2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with data: [MovieModel], indexPath: IndexPath) {
        if !data.isEmpty {
            
            guard let title =  data[indexPath.row].title, let imagePath = data[indexPath.row].posterPath  else {
                movieNameLabel.text = "empty"
                print("EMPTY")
                movieNameLabel.text = "NAFO"
                movieImage.image = UIImage(named: "nafo")
                movieImage.contentMode = .scaleAspectFill
                return
            }
            
            movieNameLabel.text = title
            movieImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(imagePath)")
            movieImage.image = UIImage(named: "house")
            movieImage.layer.masksToBounds = true
            movieImage.layer.cornerRadius = 20
            
            
        }
        
    }
}
