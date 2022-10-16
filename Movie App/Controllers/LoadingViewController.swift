//
//  SpinnerViewController.swift
//  Movie App
//
//  Created by user on 14.10.2022.
//

import UIKit

class LoadingViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    

}
