//
//  DateToStringService.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import Foundation

class DateToStringService {

	static let shared = DateToStringService()

	private init() {}

	func getDateMonthAndWeek(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func getNextDate(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func getLastDate(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMMM YYYY", calendar: Calendar.current)
		return formatter.string(from: date)
	}
}
