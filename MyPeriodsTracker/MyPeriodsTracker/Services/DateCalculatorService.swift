//
//  DateCalculatorService.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 27/06/2023.
//

import Foundation

class DateCalculatorService {

	static let shared = DateCalculatorService()

	let calendar = Calendar.current

	private init() {}

	func partOfCycleUpdate(periodStartDate: Date, periods: Int, cycle: Int, partOfCycle: MainPeriodModel.PartOfCycle) -> MainPeriodModel.PartOfCycle {
		let now = Date().midnight
		let lastPeriodStartDate = updateLastPeriodStartDate(periodStartDate, cycleLength: cycle)

		if partOfCycle == .delay,
		   delay(periodStartDate: periodStartDate, cycleLength: cycle) < 14 {
			return .delay
		} else if periods == 0 || cycle == 0 {
			return .notSet
		} else if isPeriod(startDate: lastPeriodStartDate, periodLength: periods) {
			return .period
		}
		return .offPeriod
	}

	func updateLastPeriodStartDate(_ startDate: Date, cycleLength: Int) -> Date {
		let now = Date().midnight
		var nextDate = startDate
		if nextDate > now {
			return nextDate
		}

		while nextDate <= now {
			nextDate = calendar.date(byAdding: .day, value: cycleLength, to: nextDate)!
		}

		nextDate = calendar.date(byAdding: .day, value: -cycleLength, to: nextDate)!
		return nextDate
	}

	func isPeriod(startDate: Date, periodLength: Int) -> Bool {
		let endDate = Calendar.current.date(byAdding: .day, value: periodLength, to: startDate)!
		let now = Date().midnight

		if now >= startDate, now <= endDate {
			return true
		} else if calendar.isDate(now, equalTo: startDate, toGranularity: .day) {
			return true
		}
		return false
	}

	func delay(periodStartDate: Date, cycleLength: Int) -> Int {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(periodStartDate, cycleLength: cycleLength)
		return (calendar.dateComponents([.day], from: lastPeriodStartDate, to: Date()).day ?? 0) + 1
	}
}
