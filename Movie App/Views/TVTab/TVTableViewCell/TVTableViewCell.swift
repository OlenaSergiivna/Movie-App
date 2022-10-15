//
//  TVTableViewCell.swift
//  Movie App
//
//  Created by user on 15.10.2022.
//

import UIKit

class TVTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var tvArray: [TVModel] = [] {
        didSet {
            
            self.genresCollectionView.register(UINib(nibName: "TVCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TVCollectionViewCell")
            
            genresCollectionView.dataSource = self
            genresCollectionView.delegate = self
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.genresCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.genresCollectionView.register(UINib(nibName: "TVCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TVCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override func prepareForReuse() {
        
        genresCollectionView.dataSource = nil
        genresCollectionView.delegate = nil
        genresCollectionView.reloadData()
        
//        moviesCollectionView.dataSource = self
//        moviesCollectionView.delegate = self
    }
    
}



extension TVTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !tvArray.isEmpty {
            return tvArray.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVCollectionViewCell", for: indexPath) as? TVCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tvArray, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
    
}
