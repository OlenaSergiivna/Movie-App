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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   
    }
    
    
    
    func configureMovie(with data: MovieModel) {
        
        if let title = data.title {
            
            movieImage.isHidden = false
            movieTitle.isHidden = false
            movieTitle.isEnabled = true
            
            movieTitle.text = title
        }
            if let imagePath = data.posterPath {
                
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
            
//            someBackView.layer.masksToBounds = true
//            someBackView.layer.cornerRadius = 10
        } else {
            //print("Poster Path: \(data.posterPath) - \(data.title)")
            movieImage.image = .strokedCheckmark
            movieTitle.isHidden = false
            movieTitle.isEnabled = true
        }
    }
    
    
    
    func configureTV(with data: TVModel) {
    
        movieImage.isHidden = false
        movieTitle.isHidden = false
        movieTitle.isEnabled = true
        
        movieTitle.text = data.name
        
        if let imagePath = data.posterPath {
            
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
            
            // someBackView.layer.masksToBounds = true
            // someBackView.layer.cornerRadius = 10
        } else {
            //print("Poster Path: \(data.posterPath) - \(data.name)")
            movieImage.image = .strokedCheckmark
            movieTitle.isHidden = false
            movieTitle.isEnabled = true
        }
    }
}
