//
//  PreviousRequestsTableViewCell.swift
//  Movie App
//
//  Created by user on 12.10.2022.
//

import UIKit

class PreviousRequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requestLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .black
    }
    
    func configureRequest<T>(with data: T) {
        
        if let data = data as? Media {
            switch data {
                
            case .movie(let movie):
                requestLabel.text = movie.title
                mediaTypeLabel.text = "Movie"
                
            case .tvShow(let tvShow):
                requestLabel.text = tvShow.name
                mediaTypeLabel.text = "TV Show"
            }
        } else if let data = data as? MovieModel {
            
            requestLabel.text = data.title
            mediaTypeLabel.text = "Movie"
            
        } else if let data = data as? TVModel {
            
            requestLabel.text = data.name
            mediaTypeLabel.text = "TV Show"
        }
    }
}
