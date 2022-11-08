//
//  TVTableViewCell.swift
//  Movie App
//
//  Created by user on 15.10.2022.
//

import UIKit

protocol TVCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: TVCollectionViewCell?, index: Int, didTappedInTableViewCell: TVTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class TVTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var tvCollectionView: UICollectionView!
    
    weak var cellDelegate: TVCollectionViewCellDelegate?
    
    var tvArray: [TVModel] = [] {
        didSet {
            
            self.tvCollectionView.register(UINib(nibName: "TVCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TVCollectionViewCell")
            
            tvCollectionView.dataSource = self
            tvCollectionView.delegate = self
            
            DispatchQueue.main.async {
                self.tvCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tvCollectionView.register(UINib(nibName: "TVCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TVCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override func prepareForReuse() {
        
        tvCollectionView.dataSource = nil
        tvCollectionView.delegate = nil
        tvCollectionView.reloadData()
        

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
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = tvCollectionView.cellForItem(at: indexPath) as? TVCollectionViewCell {
           cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
        
    }
    
}
