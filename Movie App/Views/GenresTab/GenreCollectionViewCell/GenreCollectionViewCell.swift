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
    
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
