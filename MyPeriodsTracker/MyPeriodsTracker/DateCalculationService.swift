//
//  DateCalculationService.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import Foundation

class DateCalculatiorService {

	static let shared = DateCalculatiorService()

	private init() {}

	func getDateMonthAndWeek(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}
}
