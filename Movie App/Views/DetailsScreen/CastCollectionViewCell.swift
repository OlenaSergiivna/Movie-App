//
//  CastCollectionViewCell.swift
//  Movie App
//
//  Created by user on 12.11.2022.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let castImage: UIImageView = {
        let castImage = UIImageView()
        //castImage.image = .strokedCheckmark
        castImage.contentMode = .scaleAspectFill
        castImage.clipsToBounds = true
        castImage.layer.cornerRadius = 20
        return castImage
    }()
    
    
    private let castLabel: UILabel = {
        let castLabel = UILabel()
        castLabel.text = ""
        castLabel.textColor = .white
        castLabel.contentMode = .center
        castLabel.font = .systemFont(ofSize: 10)
        return castLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        contentView.addSubview(castImage)
        contentView.addSubview(castLabel)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        castLabel.frame = CGRect(x: 5,
                                 y: contentView.frame.size.height - 24,
                                 width: contentView.frame.size.width,
                                 height: 16)
        
        castImage.frame = CGRect(x: 0,
                                 y: 0,
                                 width: contentView.frame.size.width - 8,
                                 height: contentView.frame.size.height - 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        castImage.image = nil
        castLabel.text = nil
    }
    
    func configure(with data: Cast) {
        print(data)
        castLabel.text = data.name

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
                    {
                        result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    }
    }
}
