//
//  DetailsScreenViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher

class DetailsScreenViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaName: UILabel!
    
    @IBOutlet weak var mediaRating: UILabel!
    
    @IBOutlet weak var mediaGenres: UILabel!
    
    @IBOutlet weak var mediaOverview: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func configure(with cell: MovieModel) {
        
        mediaName.text = cell.title
        mediaRating.text = "★ \(round((cell.voteAverage * 100))/100)"
        
        mediaOverview.text = cell.overview
        
        // MARK: Configuring movie genre
        
        var genresString = ""
        let genres = Globals.tvGenres
        
        for movieID in cell.genreIDS {
            
            for genre in genres {
                
                if movieID == genre.id {
                    genresString.append("\(genre.name). ")
                }
            }
        }
        
        mediaGenres.text = String("\(genresString)".dropLast(2))
        
        // MARK: Configuring movie image
        
        if let imagePath = cell.posterPath {
            
            let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imagePath)")
            let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
            mediaImage.kf.indicatorType = .activity
            mediaImage.kf.setImage(
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
            
        } else {
            mediaImage.image = .strokedCheckmark
        }
    }
}

