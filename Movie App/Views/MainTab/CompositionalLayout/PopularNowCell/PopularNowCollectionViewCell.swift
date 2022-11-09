//
//  PopularNowCollectionViewCell.swift
//  Movie App
//
//  Created by user on 25.10.2022.
//

import UIKit
import Kingfisher

class PopularNowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.movieImage.translatesAutoresizingMaskIntoConstraints = false
        self.movieImage.backgroundColor = .systemBackground
        self.movieImage.clipsToBounds = true
        self.movieImage.contentMode = .scaleAspectFill
        self.movieImage.layer.cornerRadius = 12
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
        movieNameLabel.text = nil
    }
    
    
    func configure(with data: [TrendyMedia], indexPath: IndexPath) {
        
        guard !data.isEmpty else {
            movieImage.image = .strokedCheckmark
            movieNameLabel.isHidden = true
            movieNameLabel.isEnabled = false
            
            return
        }
        
        movieImage.isHidden = false
        movieNameLabel.isHidden = false
        movieNameLabel.isEnabled = true
        
        if let movieName = data[indexPath.row].name {
            movieNameLabel.text = movieName
        } else {
            movieNameLabel.text = data[indexPath.row].title
        }
        
        
        guard let imagePath = data[indexPath.row].backdropPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 10)
        movieImage.kf.indicatorType = .activity
        movieImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                
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
