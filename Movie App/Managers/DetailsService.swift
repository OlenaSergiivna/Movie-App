//
//  DetailsService.swift
//  Movie App
//
//  Created by user on 07.11.2022.
//

import UIKit

struct DetailsService {
    
    static let shared = DetailsService()
    
    private init() {}
    
    func openDetailsScreen<T>(with data: T, viewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsScreenViewController") as? DetailsScreenViewController else { return }
        destinationViewController.loadViewIfNeeded()
        destinationViewController.presentationController?.delegate = viewController as? any UIAdaptivePresentationControllerDelegate
        destinationViewController.configure(with: data) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewController.navigationController?.present(destinationViewController, animated: true) {
                }
            }
            //navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}
