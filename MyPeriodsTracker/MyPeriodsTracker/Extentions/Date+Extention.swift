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

	public init?(fromString string: String) {
		let	dateFormatter = DateFormatter(dateFormat: "yyyy.MM.dd", calendar: .current)
		guard let date = dateFormatter.date(from: string) else { return nil }
		self = date
	}

	var midnight: Date{
		let calendar = Calendar.current
		return calendar.startOfDay(for: self)
	}

	var dateMonthAndWeekString: String {
		let formatter = DateFormatter(dateFormat: "d MMMM, E", calendar: Calendar.current)
		return formatter.string(from: self)
	}

	var dateAndWeekString: String {
		let formatter = DateFormatter(dateFormat: "d MMM, E", calendar: Calendar.current)
		return formatter.string(from: self)
	}

	var dateAndYearString: String {
		let formatter = DateFormatter(dateFormat: "d MMMM YYYY", calendar: Calendar.current)
		return formatter.string(from: self)
	}

	var yearMonthDayString: String {
		let formatter = DateFormatter(dateFormat: "yyyy.MM.dd", calendar: Calendar.current)
		return formatter.string(from: self)
	}
}
