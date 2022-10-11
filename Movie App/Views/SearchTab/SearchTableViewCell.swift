//
//  SearchTableViewCell.swift
//  Movie App
//
//  Created by user on 11.10.2022.
//

import UIKit

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
        
        if let title = data.title, let imagePath = data.posterPath {
            movieTitle.text = title
            //movieRating.text = String(data.voteAverage)
            movieImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(imagePath)")
            movieImage.layer.masksToBounds = true
            movieImage.layer.cornerRadius = 5
//            someBackView.layer.masksToBounds = true
//            someBackView.layer.cornerRadius = 10
        } else {
            return
        }
        
    }
    
    func configureTV(with data: TVModel) {
        
        if let imagePath = data.posterPath {
            movieTitle.text = data.name
            //movieRating.text = String(data.voteAverage)
            movieImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(imagePath)")
            movieImage.layer.masksToBounds = true
            movieImage.layer.cornerRadius = 5
//            someBackView.layer.masksToBounds = true
//            someBackView.layer.cornerRadius = 10
        } else {
            return
        }
        
    }
    
}
