//
//  TheatresCollectionViewCell.swift
//  Movie App
//
//  Created by user on 29.10.2022.
//

import UIKit

class TheatresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        movieImage.backgroundColor = .clear
        movieImage.clipsToBounds = true
        movieImage.contentMode = .scaleAspectFill
        movieImage.layer.cornerRadius = 12
    }
    
    
    func configure(with data: [MovieModel], indexPath: IndexPath) {
        
        guard let imagePath = data[indexPath.row].posterPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        movieImage.isHidden = false
        
        KingsfisherManager.shared.setImage(imagePath: imagePath, setFor: movieImage, size: "w500", cornerRadius: 0)
    }
}
