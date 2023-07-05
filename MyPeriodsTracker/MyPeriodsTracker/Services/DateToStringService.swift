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

	func dateMonthAndWeekString(from date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func dateAndWeekString(from date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func dateAndYearString(from date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d MMMM YYYY", calendar: Calendar.current)
		return formatter.string(from: date)
	}
}
