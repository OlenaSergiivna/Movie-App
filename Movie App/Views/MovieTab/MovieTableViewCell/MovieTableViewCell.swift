//
//  MovieTableViewCell.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit
import Kingfisher

protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: MovieCollectionViewCell?, index: Int, didTappedInTableViewCell: MovieTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}


class MovieTableViewCell: UITableViewCell {
    
    weak var cellDelegate: CollectionViewCellDelegate?
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var moviesArray: [MovieModel] = [] {
        didSet {
            
            self.moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
            
            moviesCollectionView.dataSource = self
            moviesCollectionView.delegate = self
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        
        moviesCollectionView.dataSource = nil
        moviesCollectionView.delegate = nil
        moviesCollectionView.reloadData()
        
//        moviesCollectionView.dataSource = self
//        moviesCollectionView.delegate = self
    }
    
    
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !moviesArray.isEmpty {
            return moviesArray.count
        } else {
            return 4
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: moviesArray, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
            
            self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
        
    }
    
    
    
        
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let viewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController {
//
//            viewController.mediaName.text = moviesArray[indexPath.row].title
//            viewController.mediaRating.text = "★ \(round((moviesArray[indexPath.row].voteAverage * 100))/100)"
//
//            viewController.mediaOverview.text = moviesArray[indexPath.row].overview
//
//            // MARK: Configuring movie genre
//
//            var genresString = ""
//            let genres = Globals.tvGenres
//
//            for movieID in moviesArray[indexPath.row].genreIDS {
//
//                for genre in genres {
//
//                    if movieID == genre.id {
//                        genresString.append("\(genre.name). ")
//                    }
//                }
//            }
//
//            viewController.mediaGenres.text = String("\(genresString)".dropLast(2))
//
//            // MARK: Configuring movie image
//
//            if let imagePath = moviesArray[indexPath.row].posterPath {
//
//                let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
//                let processor = DownsamplingImageProcessor(size: viewController.mediaImage.bounds.size)
//                |> RoundCornerImageProcessor(cornerRadius: 10)
//                viewController.mediaImage.kf.indicatorType = .activity
//                viewController.mediaImage.kf.setImage(
//                    with: url,
//                    placeholder: UIImage(named: "loading"),
//                    options: [
//                        .processor(processor),
//                        .scaleFactor(UIScreen.main.scale),
//                        .transition(.fade(1)),
//                        .cacheOriginalImage
//                    ])
//                //            {
//                //                result in
//                //                switch result {
//                //                case .success(let value):
//                //                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                //                case .failure(let error):
//                //                    print("Job failed: \(error.localizedDescription)")
//                //                }
//                //            }
//
//                //navigationController?.pushViewController(viewController, animated: true)
//
//            } else {
//                viewController.mediaImage.image = .strokedCheckmark
//            }
//
//
//
//        }
    }

