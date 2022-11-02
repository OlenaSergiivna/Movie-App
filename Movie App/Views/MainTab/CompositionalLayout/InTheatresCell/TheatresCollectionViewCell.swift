//
//  TheatresCollectionViewCell.swift
//  Movie App
//
//  Created by user on 29.10.2022.
//

import UIKit
import Kingfisher

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
        movieImage.backgroundColor = .systemBackground
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
