//
//  DateFormatter+Extention.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import Foundation

extension DateFormatter {
	convenience init(dateFormat: String, calendar: Calendar) {
		self.init()
		self.dateFormat = dateFormat
		self.calendar = calendar
//		self.locale = Locale(identifier: locale)
//		self.calendar.locale = Locale(identifier: locale)
	}
}
