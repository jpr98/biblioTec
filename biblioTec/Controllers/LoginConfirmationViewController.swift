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
	var id: String?
	
	// MARK: VC Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// dismiss keyboard
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}
	
	// MARK: Buttons
	@IBAction func confirmButtonTapped(_ sender: UIButton) {
		if checkCode() {
			print("--------------got in")
			print(email!)
			print(verificationTextField.text!)
			Auth.auth().createUser(withEmail: email!, password: verificationTextField.text!) { (authResult, error) in
				print("waiting for firebase")
				guard let user = authResult?.user,
					  let id = self.id else {
						print("returned in guard")
						return }
				ReservationService.createUser(email: id)
				print("\(user) logged in")
				UserDefault.defaults.set(id, forKey: "user")
				UserDefault.defaults.synchronize()
				print("user defaults saved")
//				if let error = error {
//					print("-----------FUCKED UP")
//					assertionFailure(error.localizedDescription)
//				}
				
				let storyboard = UIStoryboard(name: "Main", bundle: .main)
				if let initialViewController = storyboard.instantiateInitialViewController() {
					self.view.window?.rootViewController = initialViewController
					self.view.window?.makeKeyAndVisible()
				}
			}
			
		}
	}

	// MARK: Logic
	func checkCode() -> Bool{
		if let code = verificationTextField.text {
			if code == "1234" {
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







