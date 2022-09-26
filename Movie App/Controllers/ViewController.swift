//
//  ViewController.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.requestAuthentication(username: "Olena.Olena", password: "olena1611") { id in
            print("Session id (VC): \(id)")
           
        }
        
    
  
    }


}

