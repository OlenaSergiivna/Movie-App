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
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .black
//        backView.layer.borderColor = UIColor.darkGray.cgColor
//        backView.layer.borderWidth = 1
//        backView.layer.cornerRadius = 10
    }
    
    func configureRequest(request: String, type: String) {
        
        requestLabel.text = request
        mediaTypeLabel.text = type
        
    }
    
}
