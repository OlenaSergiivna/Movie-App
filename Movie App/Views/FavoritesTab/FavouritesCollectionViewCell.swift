//
//  FavouritesTableViewCell.swift
//  Movie App
//
//  Created by user on 06.10.2022.
//

import UIKit

class FavouritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var someBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 5
        
        someBackView.layer.masksToBounds = true
        someBackView.layer.cornerRadius = 10
    }
    
    
    func configure<T>(with data: T) {
        
        if let data = data as? MovieModel {
            
            configureMovie(with: data)
            
        } else if let data = data as? TVModel {
            configureTVShow(with: data)
        }
    }
    
    
    private func configureMovie(with data: MovieModel) {
        
        guard let title = data.title else { return }
        
        movieTitleLabel.text = title
        mediaTypeLabel.text = "Movie"
        
        
        guard let imagePath = data.posterPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        KingsfisherManager.shared.setImage(profilePath: imagePath, image: movieImage)
    }
    
    private func configureTVShow(with data: TVModel) {

        movieTitleLabel.text = data.name
        mediaTypeLabel.text = "TV Show"
        
        
        guard let imagePath = data.posterPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        KingsfisherManager.shared.setImage(profilePath: imagePath, image: movieImage)
    }
}
