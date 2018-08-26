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
		
		UserDefault.defaults.set(true, forKey: "hasReservation")
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3600)) {
			deleteReservation(from: email)
		}
	}
	
	// Function: disallocate reservation once one hour passes since reservation
	private static func deleteReservation(from email: String) {
		let ref = Database.database().reference().child("reservations").child(email)
		
		ref.removeValue { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
		}
		
		UserDefault.defaults.set(false, forKey: "hasReservation")
	}
	
	static func countReservations(completion: @escaping([Int])->Void) {
		let ref = Database.database().reference().child("reservations")
		
		var zonesArray: [Int] = [20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]

		ref.observeSingleEvent(of: .value) { (snapshot) in
			// looping through every user who has a reservation
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				if let value = snap.value as? [String:Any] {
					guard let zone = value["zoneId"] as? String else { return }
					switch zone {
						case "2A":
							zonesArray[0] -= 1
						case "2B":
							zonesArray[1] -= 1
						case "2C":
							zonesArray[2] -= 1
						case "2D":
							zonesArray[3] -= 1
						case "3A":
							zonesArray[4] -= 1
						case "3B":
							zonesArray[5] -= 1
						case "3C":
							zonesArray[6] -= 1
						case "3D":
							zonesArray[7] -= 1
						case "4A":
							zonesArray[8] -= 1
						case "4B":
							zonesArray[9] -= 1
						case "4C":
							zonesArray[10] -= 1
						case "4D":
							zonesArray[11] -= 1
						case "5A":
							zonesArray[12] -= 1
						case "5B":
							zonesArray[13] -= 1
						case "5C":
							zonesArray[14] -= 1
						case "5D":
							zonesArray[15] -= 1
						case "6A":
							zonesArray[16] -= 1
						case "6B":
							zonesArray[17] -= 1
						case "6C":
							zonesArray[18] -= 1
						case "6D":
							zonesArray[19] -= 1
						default:
							print("unexpected")
					}
				}
			}
			completion(zonesArray)
		}
	}
}





