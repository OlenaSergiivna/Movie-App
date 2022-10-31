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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //backView.backgroundColor = .
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func configureRequest(with data: String) {
        
        requestLabel.text = data
    }
    
}
