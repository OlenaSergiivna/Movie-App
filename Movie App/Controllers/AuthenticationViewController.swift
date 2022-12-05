//
//  ViewController.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import UIKit

// add CocoaLumberjack + set MovieVC as root VC, open AuthVC only when user in not logged in + keyChain + autologin
// add login and password validation

class AuthenticationViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.textColor = .systemGray
        passTextField.textColor = .systemGray
        
        resetForm()
        //AnimationService.shared.addAnimation(view: view)
        
    }
    
    // add language choice + implementation in all VC
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        NetworkManager.shared.requestAuthentication(username: login, password: password) { id, responseRequest, responseValidate, responseSession in
            
            Globals.sessionId = id
            print("Session id: \(Globals.sessionId)")
            
            NetworkManager.shared.getDetails(sessionId: Globals.sessionId) { [weak self] id, username, avatar in
                
                Globals.userId = id
                Globals.username = username
                Globals.avatar = avatar
//                print("User id: \(Globals.userId)")
//                print("Username: \(Globals.username)")
//                print("User avatar: \(Globals.avatar)")
                
                guard responseRequest == 200, responseValidate == 200, responseSession == 200 else { return }
                guard let self else { return }
                
                self.performSegue(withIdentifier: "authenticationPassedSegue", sender: nil)
            }
        }
    }
    
    
    func resetForm() {
        submitButton.isEnabled = true
        
//        loginError.isHidden = false
//        phoneError.isHidden = false
//        passwordError.isHidden = false
//
//        loginError.text = "Required"
//        phoneError.text = "Required"
//        passwordError.text = "Required"
        
        loginTextField.text = "Olena.Olena"
        passTextField.text = "olena1611"
    }
    
    
}
