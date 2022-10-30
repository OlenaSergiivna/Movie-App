//
//  MediaCollectionViewCell.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit
import Kingfisher

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaTitle: UILabel!
    
//    lazy var titlePaddingView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
//
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mediaImage.layer.masksToBounds = true
        self.mediaImage.layer.cornerRadius = 12
        //mediaImage.addSubview(titlePaddingView)
        
       
//        NSLayoutConstraint.activate([
//            titlePaddingView.bottomAnchor.constraint(equalTo: mediaImage.bottomAnchor),
//            titlePaddingView.heightAnchor.constraint(equalToConstant: 40),
//            titlePaddingView.leadingAnchor.constraint(equalTo: mediaImage.leadingAnchor),
//            titlePaddingView.trailingAnchor.constraint(equalTo: mediaImage.trailingAnchor)
//        ])
//
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        blurView.layer.masksToBounds = true
//        blurView.frame = titlePaddingView.bounds
//        titlePaddingView.insertSubview(blurView, at: 0)
    }
    
    
    func configureMovie(with data: [MovieModel], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        if !data.isEmpty {
            
            mediaImage.isHidden = false
            mediaTitle.isHidden = true
            mediaTitle.isEnabled = true
            
            if let title = data[indexPath.row].title {
                
                mediaTitle.text = title
            }
            
            if let imagePath = data[indexPath.row].posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w300/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 5)
                mediaImage.kf.indicatorType = .activity
                mediaImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "loading"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        
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
                
                //                let cashe = Kingfisher.ImageCache.default
                //                cashe.memoryStorage.config.countLimit = 16
                
                self.mediaImage.layer.masksToBounds = true
                self.mediaImage.layer.cornerRadius = 12
            } else {
                mediaImage.image = .strokedCheckmark
                mediaTitle.isHidden = false
                mediaTitle.isEnabled = true
            }
        }
    }
    
    
    func configureTV(with data: [TVModel], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        if !data.isEmpty {
            
            mediaImage.isHidden = false
            mediaTitle.isHidden = true
            mediaTitle.isEnabled = true
            

            mediaTitle.text = data[indexPath.row].name
           
            if let imagePath = data[indexPath.row].posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 5)
                mediaImage.kf.indicatorType = .activity
                mediaImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "loading"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        
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
                
                //                let cashe = Kingfisher.ImageCache.default
                //                cashe.memoryStorage.config.countLimit = 16
                
                self.mediaImage.layer.masksToBounds = true
                self.mediaImage.layer.cornerRadius = 12
            } else {
                mediaImage.image = .strokedCheckmark
                mediaTitle.isHidden = false
                mediaTitle.isEnabled = true
            }
            
        }
        
    }
}
