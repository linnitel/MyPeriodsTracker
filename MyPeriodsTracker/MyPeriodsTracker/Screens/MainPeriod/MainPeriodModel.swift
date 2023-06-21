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
	let ovulationPeriod: Int = 3

	var lastPeriodStartDate: Date
	var periodLength: Int
	var cycleLength: Int

	var partOfCycle: PartOfCycle = .notSet

	var nextPeriodStartDate: Date {
		Calendar.current.date(byAdding: .day, value: self.cycleLength, to: self.lastPeriodStartDate)!
	}

	func daysToPeriod(from startDate: Date) -> Int {
		Calendar.current.dateComponents([.day], from: startDate, to: self.nextPeriodStartDate).day ?? 0
	}

	func getOvulation(_ startDate: Date) -> Int {
		var ovulationDate = Calendar.current.date(byAdding: .day, value: self.ovulationDays, to: startDate)!
		let now = Date()

		var days = Calendar.current.dateComponents([.day], from: now, to: ovulationDate).day ?? 0
		if days < 0 {
			let lastPeriodStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: startDate)!
			ovulationDate = Calendar.current.date(byAdding: .day, value: self.ovulationDays, to: lastPeriodStartDate)!
			days = Calendar.current.dateComponents([.day], from: now, to: ovulationDate).day ?? 0
		}
		return days
	}

	func getFertility(_ startDate: Date) -> FertilityLevel {
		let ovulation = Calendar.current.date(byAdding: .day, value: self.ovulationDays, to: startDate)!
		let fertilityStart = Calendar.current.date(byAdding: .day, value: -self.ovulationPeriod, to: ovulation)!
		let fertilityEnd = Calendar.current.date(byAdding: .day, value: self.ovulationPeriod, to: ovulation)!
		let now = Date()
		if Calendar.current.isDate(now, equalTo: ovulation, toGranularity: .day) {
			return .veryHigh
		} else if now >= fertilityStart, now <= fertilityEnd || Calendar.current.isDate(now, equalTo: fertilityEnd, toGranularity: .day) {
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
