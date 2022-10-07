//
//  FavouritesTableViewCell.swift
//  Movie App
//
//  Created by user on 06.10.2022.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(with data: Movie) {
        
        if let title = data.title, let overview = data.overview, let imagePath = data.posterPath {
            
            movieTitleLabel.text = title
            overviewLabel.text = overview
            movieImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(imagePath)")
            
        } else {
            return
        }
       
    }
}
