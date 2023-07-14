//
//  MainPeriodModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 10/06/2023.
//

import Foundation
import SwiftUI
import os

struct MainPeriodModel {
	let ovulationDays: Int = 14
	let ovulationPeriod: Int = 4
	let calendar = Calendar.current

	let logger = Logger (subsystem: "Reddy", category: "mainScreenModel")

	var periodStartDate: Date
	var periodLength: Int
	var cycleLength: Int

	func endOfPeriodDate(now: Date) -> Date {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(
			self.periodStartDate,
			cycleLength: self.cycleLength,
			now: now
		)
		return calendar.date(byAdding: .day, value: self.periodLength, to: lastPeriodStartDate)!
	}

	func dayOfPeriod(from startDate: Date, now: Date) -> Int {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(
			self.periodStartDate,
			cycleLength: self.cycleLength,
			now: now
		)
		let days = (calendar.dateComponents([.day], from: lastPeriodStartDate, to: now).day ?? 0) + 1
		if days < 1 || days > 8 {
			logger.error("Something wrong! The cycle length is calculated badly: \(days). From \(lastPeriodStartDate) to: \(now)")
		}
		return days
	}

	func daysToPeriod(from now: Date) -> Int {
		let days = calendar.dateComponents([.day], from: now, to: DateCalculatorService.shared.nextPeriodStartDate(now: now, date: self.periodStartDate, cycle: self.cycleLength)).day ?? 0
		if days < 0 || days > 35 {
			logger.error("Something wrong! The cycle length is calculated badly: \(days). From \(periodStartDate) to: \(now) with \(cycleLength)")
		}
		return days
	}

	func getOvulation(_ now: Date) -> Int {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(self.periodStartDate, cycleLength: self.cycleLength, now: now)
		var ovulationDate = calendar.date(byAdding: .day, value: self.ovulationDays, to: lastPeriodStartDate)!

		var days = calendar.dateComponents([.day], from: now, to: ovulationDate).day ?? 0
		if days < 0 {
			let lastPeriodStartDate = calendar.date(byAdding: .day, value: cycleLength, to: lastPeriodStartDate)!
			ovulationDate = calendar.date(byAdding: .day, value: self.ovulationDays, to: lastPeriodStartDate)!
			days = calendar.dateComponents([.day], from: now, to: ovulationDate).day ?? 0
		}
		return days
	}

	func getFertility(_ now: Date) -> FertilityLevel {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(self.periodStartDate, cycleLength: self.cycleLength, now: now)
		let ovulation = calendar.date(byAdding: .day, value: self.ovulationDays, to: lastPeriodStartDate)!
		let fertilityStart = calendar.date(byAdding: .day, value: -self.ovulationPeriod, to: ovulation)!
		let fertilityEnd = calendar.date(byAdding: .day, value: self.ovulationPeriod, to: ovulation)!
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

		var stringValue: String {
			switch self {
				case .notSet:
					return "Not set"
				case .delay:
					return "Delay"
				case .offPeriod:
					return "Off period"
				case .period:
					return "Period"
			}
		}
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
