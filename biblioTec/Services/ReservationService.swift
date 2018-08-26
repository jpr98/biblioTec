//
//  ReservationService.swift
//  biblioTec
//
//  Created by Juan Pablo Ramos on 8/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ReservationService {
	// Function: create users in database, just storing all users school ids
	static func createUser(email: String) {
		let ref = Database.database().reference().child("users")
		let dict: [String:Any] = ["userid":email]
		ref.updateChildValues(dict) { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
		}
	}
	
	// Function: create a reservation once QR code scanned
	static func createReservation(for email: String, in zone: String) {
		let ref = Database.database().reference().child("reservations").child(email)
		let date = Date()
		let calendar = Calendar.current
		let hour = calendar.component(.hour, from: date)
		let minute = calendar.component(.minute, from: date)
		let time: CLong = (hour*3600000) + (minute*60000)
		let dict: [String:Any] = ["zone":zone, "time_reserved":time]
		
		ref.updateChildValues(dict) { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
		}
	}
	
	// Function: disallocate reservation once one hour passes since reservation
	static func deleteReservation(from email: String) {
		let ref = Database.database().reference().child("reservations").child(email)
		
		ref.removeValue { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
		}
	}
	
	static func countReservations(completion: @escaping([String:Int])->Void) {
		let ref = Database.database().reference().child("reservations")
		
		var dict: [String:Int] = ["2A":0,"2B":0,"2C":0,"2D":0,"3A":0,"3B":0,"3C":0,"3D":0,"4A":0,"4B":0,"4C":0,"4D":0,"5A":0,"5B":0,"5C":0,"5D":0,"6A":0,"6B":0,"6C":0,"6D":0,]
		
		ref.observeSingleEvent(of: .value) { (snapshot) in
			// looping through every user who has a reservation
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				if let value = snap.value as? [String:Any] {
					guard let zone = value["zone"] as? String else { return }
					dict[zone]! += 1
				}
			}
			completion(dict)
		}
	}
}





