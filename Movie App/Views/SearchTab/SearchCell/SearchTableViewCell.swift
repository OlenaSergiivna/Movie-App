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
    
    @IBOutlet weak var movieBackView: UIView!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var releaseYearButton: UIButton!
    
    @IBOutlet weak var productionCountryButton: UIButton!
    
    @IBOutlet weak var runtimeButton: UIButton!
    
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var firstStackView: UIStackView!
    
    @IBOutlet weak var secondStackView: UIStackView!
    
    @IBOutlet var mediaLabelsCollection: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productionCountryButton.setTitle(nil, for: .normal)
        runtimeButton.setTitle(nil, for: .normal)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backLabel.isHidden = true
        
        movieImage.backgroundColor = .clear
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 5
        
        movieBackView.layer.masksToBounds = true
        movieBackView.layer.cornerRadius = 10
        
        mediaLabelsCollection.forEach { button in
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.backgroundColor = #colorLiteral(red: 0.1176470444, green: 0.1176470444, blue: 0.1176470444, alpha: 1)
            button.titleLabel?.textColor = .white
            button.layer.cornerRadius = 15
        }
    }
    
    
    func configureMovie(with data: MovieModel) {
        
        guard let title = data.title else {
            
            movieImage.backgroundColor = .lightGray
            movieTitle.isHidden = true
            movieTitle.isEnabled = false
            
            return
        }
        
        releaseYearButton.isHidden = false
        ratingButton.isHidden = false
        firstStackView.isHidden = false
        productionCountryButton.isHidden = false
        runtimeButton.isHidden = false
        secondStackView.isHidden = false
        movieImage.isHidden = false
        movieTitle.isHidden = false
        
        
        movieTitle.text = title
        
        
        if let releaseDate = data.releaseDate {
            
            if !releaseDate.isEmpty {
                releaseYearButton.setTitle(String("\(releaseDate)".dropLast(6)), for: .normal)
            } else {
                releaseYearButton.isHidden = true
            }
        } else {
            releaseYearButton.isHidden = true
        }
        
        
        if data.voteAverage > 0 {
            ratingButton.setTitle("★ \(round((data.voteAverage * 100))/100)", for: .normal)
        } else {
            ratingButton.isHidden = true
        }
        
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
        
        
        DataManager.shared.getMovieDetails(mediaId: data.id) { [weak self] details in
            guard let self else { return }
            
            
            if let productionCountryName = details.productionCounries.first?.name {
                self.productionCountryButton.setTitle(productionCountryName, for: .normal)
            } else {
                self.productionCountryButton.isHidden = true
            }
            
            
            if let runtime = details.runtime {
                if runtime > 0 {
                    let timeInHours = self.calculateTime(Float(runtime))
                    self.runtimeButton.setTitle(String(timeInHours), for: .normal)
                } else {
                    self.runtimeButton.isHidden = true
                }
            } else {
                self.runtimeButton.isHidden = true
            }
            
            
            if self.releaseYearButton.isHidden && self.productionCountryButton.isHidden {
                self.firstStackView.isHidden = true
            }
            
            
            if self.ratingButton.isHidden && self.runtimeButton.isHidden {
                self.secondStackView.isHidden = true
            }
        }
        
        
        guard let imagePath = data.posterPath else {
            
            movieImage.backgroundColor = .lightGray
            backLabel.isHidden = false
            backLabel.text = title
            backLabel.textColor = .systemGray
            
            return
        }
        
        KingsfisherManager.shared.setImage(profilePath: imagePath, image: movieImage, cornerRadius: 5)
    }
    
    
    
    func configureTV(with data: TVModel) {
        
        releaseYearButton.isHidden = false
        ratingButton.isHidden = false
        firstStackView.isHidden = false
        productionCountryButton.isHidden = false
        runtimeButton.isHidden = false
        secondStackView.isHidden = false
        movieImage.isHidden = false
        movieTitle.isHidden = false
        
        movieTitle.text = data.name
        
        if let firstAirDate = data.firstAirDate {
            
            if !firstAirDate.isEmpty {
                releaseYearButton.setTitle(String("\(firstAirDate)".dropLast(6)), for: .normal)
            } else {
                releaseYearButton.isHidden = true
            }
        } else {
            releaseYearButton.isHidden = true
        }
        
        
        if data.voteAverage > 0 {
            ratingButton.setTitle("★ \(round((data.voteAverage * 100))/100)", for: .normal)
        } else {
            ratingButton.isHidden = true
        }
        
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
        
        DataManager.shared.getTVShowDetails(mediaId: data.id) { [weak self] details in
            guard let self else { return }
            
            if let productionCountryName = details.productionCountries.first?.name {
                
                self.productionCountryButton.setTitle(productionCountryName, for: .normal)
            } else {
                self.productionCountryButton.isHidden = true
            }
            
            
            if let runtime = details.episodeRunTime.last {
                if runtime > 0 {
                    let timeInHours = self.calculateTime(Float(runtime))
                    let runtimeString = "≈ \(timeInHours)"
                    self.runtimeButton.setTitle(String(runtimeString), for: .normal)
                } else {
                    self.runtimeButton.isHidden = true
                }
            } else {
                self.runtimeButton.isHidden = true
            }
            
            
            if self.releaseYearButton.isHidden && self.productionCountryButton.isHidden {
                self.firstStackView.isHidden = true
            }
            
            
            if self.ratingButton.isHidden && self.runtimeButton.isHidden {
                self.secondStackView.isHidden = true
            }
        }
        
        
        guard let imagePath = data.posterPath else {
            
            movieImage.backgroundColor = .lightGray
            backLabel.isHidden = false
            backLabel.text = data.name
            backLabel.textColor = .systemGray
            
            return
        }
        
        KingsfisherManager.shared.setImage(profilePath: imagePath, image: movieImage, cornerRadius: 5)
    }
    
    
    private func calculateTime(_ timeValue: Float) -> String {
        let timeMeasure = Measurement(value: Double(timeValue), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 1 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
            return String(format: "%.f %@ %.f %@", hours.value, "h", minutes, "min")
        }
        return String(format: "%.f %@", timeMeasure.value, "min")
    }
}
