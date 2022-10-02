//
//  GenresTableViewCell.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var moviesArray: [Movie] = [] {
        didSet {
            let nibCollectionCell = UINib(nibName: "GenreCollectionViewCell", bundle: nil)
            self.genresCollectionView.register(nibCollectionCell, forCellWithReuseIdentifier: "GenreCollectionViewCell")
            
             genresCollectionView.dataSource = self
             genresCollectionView.delegate = self
            
            DispatchQueue.main.async {
                self.genresCollectionView.reloadData()
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Array: \(moviesArray.count)")
        self.genresCollectionView.reloadData()
        
    }
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {

        genresCollectionView.dataSource = nil
        genresCollectionView.delegate = nil
        genresCollectionView.reloadData()
        
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
    }
    
    
}

extension GenresTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !moviesArray.isEmpty {
            return moviesArray.count
        } else {
            return 4
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        print("Array2: \(moviesArray.count)")
        
        if !moviesArray.isEmpty {
            
            if let title = self.moviesArray[indexPath.row].title {
                
                cell.movieNameLabel.text = title
                
                
                if let imagePath = moviesArray[indexPath.row].posterPath {
                    cell.movieImage.downloaded(from: "https://image.tmdb.org/t/p/w200/\(imagePath)")
                }
               
            } else {
                cell.movieNameLabel.text = "empty"
            }

            cell.movieImage.image = UIImage(named: "house")
            cell.movieImage.layer.masksToBounds = true
            cell.movieImage.layer.cornerRadius = 20
        } else {
            print("EMPTY")
            cell.movieNameLabel.text = "NAFO"
            cell.movieImage.image = UIImage(named: "nafo")
            cell.movieImage.contentMode = .scaleAspectFill
        }
        print("CV indexPath.row: \(indexPath.row) - \(cell.movieNameLabel.text!)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
}

