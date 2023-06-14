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

	func getNextDate(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func getOvulation(_ date: Date) -> Int {
//		let ovulationDate = Calendar.current.date(byAdding: .day, value: 14, to: date)
//		let now = Date()
//
//		let days = ovulationDate - now
		0
	}
}
