//
//  DetailsService.swift
//  Movie App
//
//  Created by user on 07.11.2022.
//

import UIKit

struct DetailsService: DetailsServiceProtocol {
    
    var isSecondaryScreen: Bool = false
    
    func openDetailsScreen<T>(with data: T, viewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController else { return }
        destinationViewController.loadViewIfNeeded()
        destinationViewController.presentationController?.delegate = viewController as? any UIAdaptivePresentationControllerDelegate
        
        if isSecondaryScreen { destinationViewController.isSecondaryScreen = true }
        destinationViewController.configure(with: data) {
            viewController.present(destinationViewController, animated: true)
            //navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}
