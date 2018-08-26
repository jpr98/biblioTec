//
//  LoginViewController.swift
//  biblioTec
//
//  Created by Juan Pablo Ramos on 8/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var enterButton: UIButton!
	
	// MARK: VC Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// dismiss keyboard
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}
	
	// MARK: Buttons
	@IBAction func enterButtonTapped(_ sender: UIButton) {
		performSegue(withIdentifier: Constants.SegueIdenfiers.toConfirmCode, sender: self)
	}
	
	// MARK: Segue prep
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		
		switch identifier {
		case Constants.SegueIdenfiers.toConfirmCode:
			let destination = segue.destination as! LoginConfirmationViewController
			if checkEmail() {
				destination.email = formatEmail()
				destination.id = emailTextField.text!
			}
			
		default:
			print("Unexpected segue identifier")
		}
	}
	
	// MARK: Logic
	func checkEmail() -> Bool {
		guard let email = emailTextField.text else {
			print("Error in checkEmail(): coudn't unwrap email")
			return false
		}
		
		return (email.starts(with: "A0") || email.starts(with: "a0")) && (email.count == 9)
	}
	
	func formatEmail() -> String{
		guard let email = emailTextField.text else {
			print("Error in formatEmail(): coudn't unwrap email")
			return ""
		}
		return ("\(email)@itesm.mx")
	}
}
