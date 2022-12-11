//
//  TrailerCell.swift
//  Movie App
//
//  Created by user on 11.12.2022.
//

import UIKit
import youtube_ios_player_helper

class TrailerCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "TrailerCollectionViewCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let trailerPlayer: YTPlayerView = {
        let trailerPlayer = YTPlayerView()
        trailerPlayer.translatesAutoresizingMaskIntoConstraints = false
        trailerPlayer.clipsToBounds = true
        return trailerPlayer
    }()
    
    
//    private let coverButton: UIButton = {
//        let coverButton = UIButton()
//        coverButton.translatesAutoresizingMaskIntoConstraints = false
//        coverButton.clipsToBounds = true
//        coverButton.setTitle("", for: .normal)
//        return coverButton
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
       
        //trailerPlayer.addSubview(coverButton)
        contentView.addSubview(trailerPlayer)
        
        NSLayoutConstraint.activate([
            
            trailerPlayer.topAnchor.constraint(equalTo: contentView.topAnchor),
            trailerPlayer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trailerPlayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailerPlayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
//            coverButton.topAnchor.constraint(equalTo: trailerPlayer.topAnchor),
//            coverButton.bottomAnchor.constraint(equalTo: trailerPlayer.bottomAnchor),
//            coverButton.leadingAnchor.constraint(equalTo: trailerPlayer.leadingAnchor),
//            coverButton.trailingAnchor.constraint(equalTo: trailerPlayer.trailingAnchor)
            
        ])
    }
}

