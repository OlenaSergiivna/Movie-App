//
//  TVTableViewCell.swift
//  Movie App
//
//  Created by user on 15.10.2022.
//

import UIKit

protocol TVCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: TVCollectionViewCell?, index: Int, didTappedInTableViewCell: TVTableViewCell)
}


class TVTableViewCell: UITableViewCell {
    
    weak var cellDelegate: TVCollectionViewCellDelegate?

    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var tvCollectionView: UICollectionView!
    
    var tvArray: [TVModel] = [] {
        didSet {
            
            let nibTVCollectionViewCell = UINib(nibName: "TVCollectionViewCell", bundle: nil)
            tvCollectionView.register(nibTVCollectionViewCell, forCellWithReuseIdentifier: "TVCollectionViewCell")
            
            tvCollectionView.dataSource = self
            tvCollectionView.delegate = self
            
            DispatchQueue.main.async {
                self.tvCollectionView.reloadData()
            }
        }
    }
    
    var pageCount = 1 {
        didSet {
            print("page count: \(pageCount)")
        }
    }
    
    var displayStatus = false {
        didSet {
            print("display status: \(displayStatus)")
        }
    }
    
    var totalPagesCount = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    
    func requestTVShows(by indexPath: IndexPath) {
        
        let genre = Globals.tvGenres[indexPath.row].name
        
        DataManager.shared.requestTVByGenre(genre: genre, page: pageCount) { [weak self] tvShows, totalPages in
            guard let self else { return }
            
            self.totalPagesCount = totalPages
            self.tvArray = tvShows
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tvCollectionView.dataSource = nil
        tvCollectionView.delegate = nil
        tvCollectionView.reloadData()
    }
}


extension TVTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !tvArray.isEmpty else {
            return 4
        }
        return tvArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVCollectionViewCell", for: indexPath) as? TVCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tvArray, indexPath: indexPath)
        return cell
    }
}


extension TVTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = tvCollectionView.cellForItem(at: indexPath) as? TVCollectionViewCell else { return }

        cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard indexPath.row == tvArray.count - 3, totalPagesCount > pageCount, displayStatus == false else { return }
        
        displayStatus = true
        pageCount += 1
        
        guard let genre = genreLabel.text else { return }
        
        DataManager.shared.requestTVByGenre(genre: genre, page: self.pageCount) { [weak self] tvShows, _ in
            guard let self else { return }
            
            self.tvArray.append(contentsOf: tvShows)
            
            DispatchQueue.main.async {
                self.tvCollectionView.reloadData()
            }
            
            self.displayStatus = false
        }
    }
}


extension TVTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
}
