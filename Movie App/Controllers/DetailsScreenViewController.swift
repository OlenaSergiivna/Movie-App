//
//  DetailsScreenViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher

class DetailsScreenViewController: UIViewController {
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaName: UILabel!
    
    @IBOutlet weak var mediaRating: UILabel!
    
    @IBOutlet weak var mediaGenres: UILabel!
    
    @IBOutlet weak var mediaOverview: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    
    func configure(with cell: MovieModel) {
            
            self.mediaName.text = cell.title
            self.mediaRating.text = "★ \(round((cell.voteAverage * 100))/100)"
            
            self.mediaOverview.text = cell.overview
            
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
            
            self.mediaGenres.text = String("\(genresString)".dropLast(2))
            
            // MARK: Configuring movie image
            
            if let imagePath = cell.posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: self.mediaImage.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 10)
                self.mediaImage.kf.indicatorType = .activity
                self.mediaImage.kf.setImage(
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
                
                //navigationController?.pushViewController(viewController, animated: true)
                
            } else {
                self.mediaImage.image = .strokedCheckmark
            }
        }
    }

