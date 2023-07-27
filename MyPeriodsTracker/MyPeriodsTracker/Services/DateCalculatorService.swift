//
//  DateCalculatorService.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 27/06/2023.
//

import Foundation
import os

class DateCalculatorService {

	static let shared = DateCalculatorService()

	let calendar = Calendar.current
	let logger = Logger (subsystem: "Reddy", category: "DateCalculationService")

	private init() {}

	func partOfCycleUpdate(periodStartDate: Date, periods: Int, cycle: Int, partOfCycle: MainPeriodModel.PartOfCycle, now: Date) -> MainPeriodModel.PartOfCycle {
		let lastPeriodStartDate = updateLastPeriodStartDate(periodStartDate, cycleLength: cycle, periodLength: periods, now: now)

		if partOfCycle == .delay,
		   delay(periodStartDate: periodStartDate, cycleLength: cycle, period: periods, now: now) < 14 {
			return .delay
		} else if isPeriod(startDate: lastPeriodStartDate, periodLength: periods, now: now) {
			return .period
		}
		return .offPeriod
	}

	func updateLastPeriodStartDate(_ startDate: Date, cycleLength: Int, periodLength: Int, now: Date) -> Date {
		var lastPeriodDate = startDate

		guard cycleLength != 0 else { return lastPeriodDate }

		if lastPeriodDate > now {
			return lastPeriodDate
		}

		while lastPeriodDate <= now {
			lastPeriodDate = calendar.date(byAdding: .day, value: cycleLength, to: lastPeriodDate)!
		}
		let endDate = Calendar.current.date(byAdding: .day, value: periodLength, to: lastPeriodDate)!

		lastPeriodDate = calendar.date(byAdding: .day, value: -cycleLength, to: lastPeriodDate)!

		if now >= endDate || Calendar.current.isDate(now, equalTo: endDate, toGranularity: .day) {
			lastPeriodDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: lastPeriodDate)!
		}
		return lastPeriodDate
	}

	func nextPeriodStartDate(now: Date, date: Date, cycle: Int, period: Int) -> Date {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(date, cycleLength: cycle, periodLength: period, now: now)
		return calendar.date(byAdding: .day, value: cycle, to: lastPeriodStartDate)!
	}

	func calculateOneDayBeforePeriod(now: Date, date: Date, cycle: Int, period: Int) -> Date {
		let nextDate = nextPeriodStartDate(now: now, date: date, cycle: cycle, period: period)
		return calendar.date(byAdding: .day, value: -1, to: nextDate)!
	}

	func isPeriod(startDate: Date, periodLength: Int, now: Date) -> Bool {
		let endDate = Calendar.current.date(byAdding: .day, value: periodLength, to: startDate)!

		if now >= startDate, now < endDate {
			return true
		} else if calendar.isDate(now, equalTo: startDate, toGranularity: .day) {
			return true
		}
		return false
	}

	func delay(periodStartDate: Date, cycleLength: Int, period: Int, now: Date) -> Int {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(periodStartDate, cycleLength: cycleLength, periodLength: period, now: now)
		let delay = (calendar.dateComponents([.day], from: lastPeriodStartDate, to: now).day ?? 0) + 1
		if delay < 0 || delay > 15 {
			self.logger.error("Error! The delay = \(delay), incoming data: period start date: \(lastPeriodStartDate), cycle: \(cycleLength), now: \(now)")
		}
		return delay
	}

	func getOvulationDate(now: Date, startDate: Date, cycle: Int, period: Int) -> Date {
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(startDate, cycleLength: cycle, periodLength: period, now: now)
		return calendar.date(byAdding: .day, value: 14, to: lastPeriodStartDate)!
	}
}
