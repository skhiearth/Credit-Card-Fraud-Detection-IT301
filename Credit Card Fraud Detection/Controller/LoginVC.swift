//
//  LoginVC.swift
//  Credit Card Fraud Detection
//
//  Created by Simran Gogia and Utkarsh Sharma on 14/03/21.
//

import UIKit
import LocalAuthentication

class LoginVC: UIViewController {

    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: IBActions
    @IBAction func bankBtnPresseed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BankVC") as! BankVC
        nextViewController.setupAsBank()
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func userBtnPressed(_ sender: Any) {
        
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BankVC") as! BankVC
                            nextViewController.setupAsUser()
                            nextViewController.modalPresentationStyle = .fullScreen
                            self!.present(nextViewController, animated:true, completion:nil)
                        } else {
                            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Okay", style: .default))
                            self?.present(ac, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
    }
}
