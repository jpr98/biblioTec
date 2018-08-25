//
//  LoginConfirmationViewController.swift
//  biblioTec
//
//  Created by Juan Pablo Ramos on 8/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginConfirmationViewController: UIViewController {
	
	@IBOutlet weak var verificationTextField: UITextField!
	@IBOutlet weak var confirmButton: UIButton!
	var email: String?
	
	// MARK: VC Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: Buttons
	@IBAction func confirmButtonTapped(_ sender: UIButton) {
		if checkCode() {
			Auth.auth().createUser(withEmail: email!, password: verificationTextField.text!) { (authResult, error) in
				
				guard let user = authResult?.user else { return }
			}
		}
	}
	
	// MARK: Logic
	func checkCode() -> Bool{
		if let code = verificationTextField.text {
			if code == "TCBB8HAS0L" {
				return true
			} else {
				return false
			}
		} else {
			print("Error in checkCode(): couldn't unwrap code")
			return false
		}
	}
	
}







