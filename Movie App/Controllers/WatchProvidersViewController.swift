//
//  WatchProvidersViewController.swift
//  Movie App
//
//  Created by user on 13.12.2022.
//

import UIKit

class WatchProvidersViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }

    @IBOutlet weak var providersTableView: UITableView!
    
    var providersArray: [ProviderDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        providersTableView.dataSource = self
        providersTableView.delegate = self
        
        providersTableView.register(UINib(nibName: "ProviderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProviderTableViewCell")
    }
    
    
    func configure(mediaID: Int, mediaType: String, completion: @escaping() -> Void) {
        DataManager.shared.getProviders(mediaType: mediaType, mediaID: mediaID) { [weak self] data in
            guard let self else { return }
            
            print(data)
        }
    }
    

    

}


extension WatchProvidersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        providersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = providersTableView.dequeueReusableCell(withIdentifier: "ProviderTableViewCell", for: indexPath) as? ProviderTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: providersArray[indexPath.row])
        return cell
    }
    
    
}


extension WatchProvidersViewController: UITableViewDelegate {
    
}
