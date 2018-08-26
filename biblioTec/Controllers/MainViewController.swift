//
//  MainViewController.swift
//  biblioTec
//
//  Created by Ricardo Ramirez on 8/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class MainViewController: UIViewController {
    
	@IBOutlet weak var currentLabel: UILabel!
	@IBOutlet weak var buscarLugarBtn: UIButton!
    @IBOutlet weak var scanQrBtn: UIButton!
    
    @IBAction func unwind(segue:UIStoryboardSegue) { }
    
    private let animators: (LayoutAttributesAnimator, Bool, Int, Int) = (ZoomInOutAttributesAnimator(), true, 1, 1)
                                                                           
    
    @IBAction func buscarLugarPressed(_ sender: Any) {
        performSegue(withIdentifier: "toLookForPlace", sender: self)
    }
    
    @IBAction func scanQrPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		if let user = UserDefault.defaults.string(forKey: "user") {
			currentLabel.text = user.uppercased()
		}
		
		if UserDefault.defaults.bool(forKey: "hasReserved") {
			scanQrBtn.isEnabled = false
			scanQrBtn.layer.backgroundColor = UIColor.gray.cgColor
		}
        buscarLugarBtn.layer.cornerRadius = 10
        scanQrBtn.layer.cornerRadius = 10
		//UserDefault.defaults.set(false, forKey: "hasReserved")
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UserDefault.defaults.bool(forKey: "hasReserved") {
			scanQrBtn.isEnabled = false
			scanQrBtn.layer.backgroundColor = UIColor.gray.cgColor
		}
	}
    
    
}
