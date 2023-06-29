//
//  Date+Extention.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 28/06/2023.
//

import Foundation

extension Date: RawRepresentable{
	public var rawValue: String {
		self.timeIntervalSince1970.description
	}

	public init?(rawValue: String) {
		guard let interval = TimeInterval(rawValue) else {
			return nil
		}
		self = Date(timeIntervalSince1970: interval)
	}

	var midnight: Date{
		let calendar = Calendar.current
		return calendar.startOfDay(for: self)
	}
}
