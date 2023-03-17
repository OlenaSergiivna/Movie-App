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
    
    @IBOutlet weak var ratingLabel: PaddingLabel!
    
    @IBOutlet weak var releaseYearLabel: PaddingLabel!
    
    @IBOutlet weak var productionCountryLabel: PaddingLabel!
    
    @IBOutlet weak var runtimeLabel: PaddingLabel!
    
    @IBOutlet weak var episodesCountLabel: PaddingLabel!
    
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var firstStackView: UIStackView!
    
    @IBOutlet weak var secondStackView: UIStackView!
    
    @IBOutlet var mediaLabelsCollection: [PaddingLabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
        movieTitle.text = nil
        genresLabel.text = nil
        backLabel.text = nil
        
        movieImage.isHidden = false
        movieTitle.isHidden = false
        genresLabel.isHidden = false
        
        firstStackView.isHidden = true
        secondStackView.isHidden = true
        backLabel.isHidden = true
        
        mediaLabelsCollection.forEach { label in
            label.isHidden = true
            label.text = nil
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        movieImage.backgroundColor = .clear
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 5
        
        movieBackView.layer.masksToBounds = true
        movieBackView.layer.cornerRadius = 10
        
        mediaLabelsCollection.forEach { label in
            label.clipsToBounds = true
            label.backgroundColor = #colorLiteral(red: 0.1176470444, green: 0.1176470444, blue: 0.1176470444, alpha: 1)
            label.textColor = .white
            label.layer.cornerRadius = 10
        }
    }
    
    
    func configureMovie(with data: MovieModel) {
        
        movieImage.isHidden = false
        movieTitle.isHidden = false
        genresLabel.isHidden = false
        
        firstStackView.isHidden = true
        secondStackView.isHidden = true
        backLabel.isHidden = true
        
        mediaLabelsCollection.forEach { label in
            label.isHidden = true
            label.text = nil
        }
        
        getMovieDetails(with: data) {
            
            guard let title = data.title else {
                
                self.movieImage.isHidden = true
                self.movieTitle.isHidden = true
                
                return
            }
            
            self.movieTitle.text = title
            
            
            if let releaseDate = data.releaseDate, !releaseDate.isEmpty {
                self.releaseYearLabel.text = String("\(releaseDate)".dropLast(6))
                self.releaseYearLabel.applyPadding()
                self.releaseYearLabel.isHidden = false
            }
            
            
            if data.voteAverage > 0 {
                self.ratingLabel.text = "★ \(round((data.voteAverage * 100))/100)"
                self.ratingLabel.isHidden = false
                self.ratingLabel.applyPadding()
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
            
            self.genresLabel.text = String("\(genresString)".dropLast(2))
            
            
            if !self.releaseYearLabel.isHidden || !self.productionCountryLabel.isHidden {
                self.firstStackView.isHidden = false
            }
            
            if !self.ratingLabel.isHidden || !self.runtimeLabel.isHidden {
                self.secondStackView.isHidden = false
            }
            
            guard let imagePath = data.posterPath else {
                
                self.movieImage.isHidden = true
                self.backLabel.isHidden = false
                self.backLabel.text = title
                self.backLabel.textColor = .darkGray
                
                return
            }
            
            KingsfisherManager.shared.setImage(profilePath: imagePath, image: self.movieImage, size: "w342", cornerRadius: 5)
        }
    }
    
    
    func configureTV(with data: TVModel) {
        
        movieImage.isHidden = false
        movieTitle.isHidden = false
        genresLabel.isHidden = false
        
        firstStackView.isHidden = true
        secondStackView.isHidden = true
        backLabel.isHidden = true
        
        mediaLabelsCollection.forEach { label in
            label.isHidden = true
            label.text = nil
        }
        
        getTVDetails(with: data) {
            
            self.movieTitle.text = data.name
            
            if let firstAirDate = data.firstAirDate, !firstAirDate.isEmpty {
                self.releaseYearLabel.text = String("\(firstAirDate)".dropLast(6))
                self.releaseYearLabel.applyPadding()
                self.releaseYearLabel.isHidden = false
            }
            
            
            if data.voteAverage > 0 {
                self.ratingLabel.text = "★ \(round((data.voteAverage * 100))/100)"
                self.ratingLabel.isHidden = false
                self.ratingLabel.applyPadding()
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
            
            self.genresLabel.text = String("\(genresString)".dropLast(2))
            
            
            if !self.releaseYearLabel.isHidden || !self.productionCountryLabel.isHidden {
                self.firstStackView.isHidden = false
            }
            
            
            if !self.ratingLabel.isHidden || !self.runtimeLabel.isHidden || !self.episodesCountLabel.isHidden {
                self.secondStackView.isHidden = false
            }
            
            guard let imagePath = data.posterPath else {
                
                self.movieImage.isHidden = true
                self.backLabel.isHidden = false
                self.backLabel.text = data.name
                self.backLabel.textColor = .darkGray
                
                return
            }
            
            KingsfisherManager.shared.setImage(profilePath: imagePath, image: self.movieImage, size: "w342", cornerRadius: 5)
        }
    }
    
    
    private func getMovieDetails(with data: MovieModel, completion: @escaping () -> Void) {
        
        DataManager.shared.getMovieDetails(mediaId: data.id) { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let details):
                
                if let productionCountryName = details.productionCounries.first?.name {
                    self.productionCountryLabel.text = productionCountryName
                    self.productionCountryLabel.isHidden = false
                    self.productionCountryLabel.applyPadding()
                }
                
                if let runtime = details.runtime, runtime > 0 {
                    let timeInHours = self.calculateTime(Float(runtime))
                    self.runtimeLabel.text = String(timeInHours)
                    self.runtimeLabel.isHidden = false
                    self.runtimeLabel.applyPadding()
                }
                completion()
                
            case .failure(let error):
                print("Error with getting details for movie: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    
    private func getTVDetails(with data: TVModel, completion: @escaping () -> Void) {
        
        DataManager.shared.getTVShowDetails(mediaId: data.id) { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let details):
                
                if let productionCountryName = details.productionCountries.first?.name {
                    self.productionCountryLabel.text = productionCountryName
                    self.productionCountryLabel.isHidden = false
                    self.productionCountryLabel.applyPadding()
                }
                
                
                var episodesString = "\(String(details.numberOfEpisodes))"
                
                if details.numberOfEpisodes > 1 {
                    episodesString += " episodes"
                } else {
                    episodesString += " episode"
                }
                
                self.episodesCountLabel.text = episodesString
                
                if details.numberOfEpisodes > 0 {
                    self.episodesCountLabel.isHidden = false
                    self.episodesCountLabel.applyPadding()
                }
                
                completion()
                
            case .failure(let error):
                print("Error with getting details for movie: \(error.localizedDescription)")
                completion()
            }
        }
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


extension PaddingLabel {
    
    func applyPadding() {
        
        self.paddingLeft = 10
        self.paddingRight = 10
        self.paddingTop = 5
        self.paddingBottom = 5
    }
}
