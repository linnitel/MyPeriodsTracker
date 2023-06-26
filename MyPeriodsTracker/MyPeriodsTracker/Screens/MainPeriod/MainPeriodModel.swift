//
//  MainPeriodModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 10/06/2023.
//

import Foundation
import SwiftUI

struct MainPeriodModel {
	let ovulationDays: Int = 14
	let ovulationPeriod: Int = 4
	let calendar = Calendar.current
	let now = Date()

	var periodStartDate: Date
	var periodLength: Int
	var cycleLength: Int

	var partOfCycle: PartOfCycle = .notSet

	var lastPeriodStartDate: Date {
		let now = Date()
		var nextDate = periodStartDate
		if nextDate > now {
			return nextDate
		}

		while nextDate < now, !Calendar.current.isDate(now, equalTo: nextDate, toGranularity: .day) {
			nextDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: nextDate)!
		}

		nextDate = Calendar.current.date(byAdding: .day, value: -cycleLength, to: nextDate)!
		return nextDate
	}

	var nextPeriodStartDate: Date {
		calendar.date(byAdding: .day, value: self.cycleLength, to: self.lastPeriodStartDate)!
	}

	var endOfPeriodDate: Date {
		calendar.date(byAdding: .day, value: self.periodLength, to: self.lastPeriodStartDate)!
	}

	var dayOfPeriod: Int {
		calendar.dateComponents([.day], from: self.lastPeriodStartDate, to: Date()).day ?? 0
	}

	var delay: Int {
		calendar.dateComponents([.day], from: self.lastPeriodStartDate, to: Date()).day ?? 0
	}

	var early: Int {
		calendar.dateComponents([.day], from: self.nextPeriodStartDate, to: Date()).day ?? 0
	}

	func daysToPeriod(from startDate: Date) -> Int {
		calendar.dateComponents([.day], from: startDate, to: self.nextPeriodStartDate).day ?? 0
	}

	func getOvulation() -> Int {
		var ovulationDate = calendar.date(byAdding: .day, value: self.ovulationDays, to: self.lastPeriodStartDate)!
		let now = Date()

		var days = calendar.dateComponents([.day], from: now, to: ovulationDate).day ?? 0
		if days < 0 {
			let lastPeriodStartDate = calendar.date(byAdding: .day, value: cycleLength, to: self.lastPeriodStartDate)!
			ovulationDate = calendar.date(byAdding: .day, value: self.ovulationDays, to: lastPeriodStartDate)!
			days = calendar.dateComponents([.day], from: now, to: ovulationDate).day ?? 0
		}
		return days
	}

	func getFertility() -> FertilityLevel {
		let ovulation = calendar.date(byAdding: .day, value: self.ovulationDays, to: self.lastPeriodStartDate)!
		let fertilityStart = calendar.date(byAdding: .day, value: -self.ovulationPeriod, to: ovulation)!
		let fertilityEnd = calendar.date(byAdding: .day, value: self.ovulationPeriod, to: ovulation)!
		let now = Date()
		if calendar.isDate(now, equalTo: ovulation, toGranularity: .day) {
			return .veryHigh
		} else if now >= fertilityStart, now <= fertilityEnd || calendar.isDate(now, equalTo: fertilityEnd, toGranularity: .day) {
			return .high
		} else {
			return .low
		}
	}

	enum PartOfCycle: Int {
		case notSet = 0
		case offPeriod = 1
		case period = 2
		case delay = 3
		case early = 4
	}

	enum FertilityLevel: String {
		case low
		case high
		case veryHigh

		var level: String {
			switch self {
				case .low:
					return "Low"
				case .high:
					return "High"
				case .veryHigh:
					return "Very high"
			}
		}

		var color: Color {
			switch self {
				case .low:
					return .black
				case .high, .veryHigh:
					return .accentColor
			}
		}
	}
}
