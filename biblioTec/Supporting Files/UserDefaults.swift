//
//  File.swift
//  biblioTec
//
//  Created by Juan Pablo Ramos on 8/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation

struct UserDefault {
	static let defaults = UserDefaults.standard
	
	static func makingReservation() {
		defaults.set(true, forKey: "hasReserved")
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3600)) {
			defaults.set(false, forKey: "hasReserved")
		}
	}
}
