//
//  ViewController.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
        
    }
    
    // add language choice + implementation in all VC
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        NetworkManager.shared.requestAuthentication(username: login, password: password) { id, responseRequest, responseValidate, responseSession in
            
            print(responseRequest, responseValidate, responseSession)
            Globals.sessionId = id
            print("Session id: \(Globals.sessionId)")
            
            NetworkManager.shared.getDetails(sessionId: Globals.sessionId) { [weak self] userId in
                guard let self else {
                    return
                }
                
                Globals.userId = userId
                print("User id: \(Globals.userId)")
                
                if responseRequest == 200 {
                    print(responseRequest)
                    if responseValidate == 200 {
                        print(responseValidate)
                        if responseSession == 200 {
                            print(responseSession)
                            self.performSegue(withIdentifier: "authenticationPassedSegue", sender: nil)
                        }
                    }
                }
            }
            
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
        
        loginTextField.text = "Olena.Olena"
        passTextField.text = "olena1611"
    }
    
    
}
