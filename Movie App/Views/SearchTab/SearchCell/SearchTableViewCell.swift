//
//  SearchTableViewCell.swift
//  Movie App
//
//  Created by user on 11.10.2022.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.movieImage.layer.masksToBounds = true
        self.movieImage.layer.cornerRadius = 12
    }
    
    
    func configureMovie(with data: MovieModel) {
        
        guard let title = data.title else {
            
            movieImage.image = .strokedCheckmark
            movieTitle.isHidden = true
            movieTitle.isEnabled = false
            
            return
        }
        
        movieImage.isHidden = false
        movieTitle.isHidden = false
        movieTitle.isEnabled = true
        
        movieTitle.text = title
        
        guard let imagePath = data.posterPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        movieImage.kf.indicatorType = .activity
        movieImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading"),
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
    
    
    
    func configureTV(with data: TVModel) {
        
        movieImage.isHidden = false
        movieTitle.isHidden = false
        movieTitle.isEnabled = true
        
        movieTitle.text = data.name
        
        guard let imagePath = data.posterPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 5)
        movieImage.kf.indicatorType = .activity
        movieImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading"),
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
