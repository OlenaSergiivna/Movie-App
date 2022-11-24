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
    
    @IBOutlet weak var movieBackView: UIView!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var releaseYearButton: UIButton!
    
    @IBOutlet weak var productionCountryButton: UIButton!
    
    @IBOutlet var mediaLabelsCollection: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 5
        
        movieBackView.layer.masksToBounds = true
        movieBackView.layer.cornerRadius = 10
        
        mediaLabelsCollection.forEach { button in
            button.layer.masksToBounds = true
            
            button.backgroundColor = UIColor(red: 23, green: 23, blue: 23, alpha: 1)
            button.titleLabel?.textColor = .white
            button.layer.cornerRadius = 15
        }
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
        
        guard let releaseDate = data.releaseDate else { return }
        
        releaseYearButton.setTitle(String("\(releaseDate)".dropLast(6)), for: .normal)
        
        ratingButton.setTitle("★ \(round((data.voteAverage * 100))/100)", for: .normal)
        
        var genresString = ""
        let genres = Globals.movieGenres
        
        for movieID in data.genreIDS {
            
            for genre in genres {
                
                if movieID == genre.id {
                    genresString.append("\(genre.name). ")
                }
            }
        }
        
        genresLabel.text = String("\(genresString)".dropLast(2))
        
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
        releaseYearButton.setTitle(data.firstAirDate, for: .normal)
        
        ratingButton.setTitle("★ \(round((data.voteAverage * 100))/100)", for: .normal)
        
        var genresString = ""
        let genres = Globals.tvGenres
        
        for tvID in data.genreIDS {
            
            for genre in genres {
                
                if tvID == genre.id {
                    genresString.append("\(genre.name). ")
                }
            }
        }
        
        genresLabel.text = String("\(genresString)".dropLast(2))
        
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
