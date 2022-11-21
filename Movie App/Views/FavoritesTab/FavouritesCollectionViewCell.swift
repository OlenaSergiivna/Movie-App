//
//  FavouritesTableViewCell.swift
//  Movie App
//
//  Created by user on 06.10.2022.
//

import UIKit
import Kingfisher

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
    
    
    func configure(with data: MovieModel) {
        
        guard let title = data.title else { return }
        
        movieTitleLabel.text = title
        mediaTypeLabel.text = "Movie"
        
        
        guard let imagePath = data.posterPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        movieImage.kf.indicatorType = .activity
        movieImage.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        //            {
        //                result in
        //                switch result {
        //                case .success(let value):
        //                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
        //                case .failure(let error):
        //                    print("Job failed: \(error.localizedDescription)")
        //                }
        //            }
    }
}
