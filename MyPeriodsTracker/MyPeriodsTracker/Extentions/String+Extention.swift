//
//  String+Extention.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import Foundation

public extension String {

	func localized() -> String {
		return NSLocalizedString(self, comment: "")
	}
}
