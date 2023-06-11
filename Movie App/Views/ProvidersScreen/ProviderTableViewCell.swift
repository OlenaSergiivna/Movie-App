//
//  ProviderTableViewCell.swift
//  Movie App
//
//  Created by user on 13.12.2022.
//

import UIKit

class ProviderTableViewCell: UITableViewCell {

    @IBOutlet weak var providersName: UILabel!
    
    @IBOutlet weak var providersLogo: UIImageView!
    
    @IBOutlet weak var watchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func watchButtonTapped(_ sender: UIButton) {
    }
    
    
    func configure(with provider: ProviderDetails) {
        providersName.text = provider.providerName
        
        KingsfisherManager.shared.setImage(imagePath: provider.logoPath, setFor: providersLogo)
    }
}
