//
//  CastCollectionViewCell.swift
//  Movie App
//
//  Created by user on 12.11.2022.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "CastCollectionViewCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let castImage: UIImageView = {
        let castImage = UIImageView()
        castImage.translatesAutoresizingMaskIntoConstraints = false
        castImage.contentMode = .scaleAspectFill
        castImage.clipsToBounds = true
        castImage.layer.cornerRadius = 20
        return castImage
    }()
    
    
    private let castLabel: UILabel = {
        let castLabel = UILabel()
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castLabel.text = ""
        castLabel.textColor = .white
        castLabel.textAlignment = .center
        castLabel.contentMode = .center
        castLabel.font = .systemFont(ofSize: 10)
        castLabel.adjustsFontSizeToFitWidth = true
        return castLabel
    }()
    
    private let characterLabel: UILabel = {
        let characterLabel = UILabel()
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.text = "Hello"
        characterLabel.textColor = .darkGray
        characterLabel.contentMode = .center
        characterLabel.textAlignment = .center
        characterLabel.font = .systemFont(ofSize: 8)
        characterLabel.adjustsFontSizeToFitWidth = true
        characterLabel.minimumScaleFactor = 0.3
        return characterLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
       
        contentView.addSubview(castImage)
        contentView.addSubview(castLabel)
        contentView.addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
            
            castImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            castImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            castImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height - 30),
            
            castLabel.topAnchor.constraint(equalTo: castImage.bottomAnchor, constant: 4),
            castLabel.leadingAnchor.constraint(greaterThanOrEqualTo: castImage.leadingAnchor),
            castLabel.trailingAnchor.constraint(greaterThanOrEqualTo: castImage.trailingAnchor),
            castLabel.centerXAnchor.constraint(equalTo: castImage.centerXAnchor),
            
            characterLabel.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 4),
            characterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            characterLabel.leadingAnchor.constraint(greaterThanOrEqualTo: castLabel.leadingAnchor),
            characterLabel.centerXAnchor.constraint(equalTo: castLabel.centerXAnchor),
            characterLabel.trailingAnchor.constraint(greaterThanOrEqualTo: castLabel.trailingAnchor)
        ])
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
      
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        castImage.image = nil
        castLabel.text = nil
        characterLabel.text = nil
    }
    
    func configure(with data: Cast) {
        
        castLabel.text = data.name
        
        
        if let characterString = data.character {
            characterLabel.text = characterString
            
            if let index = characterString.range(of: "/")?.lowerBound {
                let substring = characterString[..<index]
                
                characterLabel.text = String(substring.dropLast(1))
            }
        }
        
        
        guard let profilePath = data.profilePath else {

            castImage.image = .strokedCheckmark
            return
        }

        let url = URL(string: "https://image.tmdb.org/t/p/original/\(profilePath)")
        
        let processor = DownsamplingImageProcessor(size: castImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        castImage.kf.indicatorType = .activity
        castImage.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),

            ])
//                    {
//                        result in
//                        switch result {
//                        case .success(let value):
//                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                        case .failure(let error):
//                            print("Job failed: \(error.localizedDescription)")
//                        }
//                    }
    }
}
