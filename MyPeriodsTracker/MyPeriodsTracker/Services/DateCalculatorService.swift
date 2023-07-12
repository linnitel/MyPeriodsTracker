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

	func partOfCycleUpdate(periodStartDate: Date, periods: Int, cycle: Int, partOfCycle: MainPeriodModel.PartOfCycle, now: Date) -> MainPeriodModel.PartOfCycle {
		let lastPeriodStartDate = updateLastPeriodStartDate(periodStartDate, cycleLength: cycle, now: now)

		if partOfCycle == .delay,
		   delay(periodStartDate: periodStartDate, cycleLength: cycle, now: now) < 14 {
			return .delay
		} else if isPeriod(startDate: lastPeriodStartDate, periodLength: periods, now: now) {
			return .period
		}
		return .offPeriod
	}

	func updateLastPeriodStartDate(_ startDate: Date, cycleLength: Int, now: Date) -> Date {
		var nextDate = startDate

		guard cycleLength != 0 else { return nextDate }

		if nextDate > now {
			return nextDate
		}

		while nextDate <= now {
			nextDate = calendar.date(byAdding: .day, value: cycleLength, to: nextDate)!
		}

		nextDate = calendar.date(byAdding: .day, value: -cycleLength, to: nextDate)!
		return nextDate
	}

	func nextPeriodStartDate(now: Date, date: Date, cycle: Int) -> Date {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(date, cycleLength: cycle, now: now)
		return calendar.date(byAdding: .day, value: cycle, to: lastPeriodStartDate)!
	}

	func calculateOneDayBeforePeriod(now: Date, date: Date, cycle: Int) -> Date {
		let nextDate = nextPeriodStartDate(now: now, date: date, cycle: cycle)
		return calendar.date(byAdding: .day, value: -1, to: nextDate)!
	}

	func isPeriod(startDate: Date, periodLength: Int, now: Date) -> Bool {
		let endDate = Calendar.current.date(byAdding: .day, value: periodLength, to: startDate)!

		if now >= startDate, now <= endDate {
			return true
		} else if calendar.isDate(now, equalTo: startDate, toGranularity: .day) {
			return true
		}
		return false
	}

	func delay(periodStartDate: Date, cycleLength: Int, now: Date) -> Int {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(periodStartDate, cycleLength: cycleLength, now: now)
		return (calendar.dateComponents([.day], from: lastPeriodStartDate, to: now).day ?? 0) + 1
	}

	func getOvulationDate(now: Date, startDate: Date, cycle: Int) -> Date {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(startDate, cycleLength: cycle, now: now)
		return calendar.date(byAdding: .day, value: 14, to: lastPeriodStartDate)!
	}
}
