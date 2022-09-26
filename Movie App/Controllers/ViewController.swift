//
//  ViewController.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import UIKit

class ViewController: UIViewController {

    var sessionId = ""
    
    @IBOutlet weak var loginTextField: UITextField!

    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
        

    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passTextField.text else { return }

        NetworkManager.shared.requestAuthentication(username: login, password: password) { [weak self] id in
            self?.sessionId = id
            print("Session id (VC): \(self?.sessionId ?? "0")")
           
        }
        
    }
    
    func resetForm() {
        submitButton.isEnabled = true

//        loginError.isHidden = false
//        phoneError.isHidden = false
//        passwordError.isHidden = false

//        loginError.text = "Required"
//        phoneError.text = "Required"
//        passwordError.text = "Required"

        loginTextField.text = ""
        passTextField.text = ""
    }
    
    
}

