//
//  DetailsService.swift
//  Movie App
//
//  Created by user on 07.11.2022.
//

import UIKit

struct DetailsService {
    
    static let shared = DetailsService()
    
    func openDetailsScreen<T>(with data: T, navigationController: UINavigationController?) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController else { return }
        destinationViewController.loadViewIfNeeded()
        
        destinationViewController.configure(with: data)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
