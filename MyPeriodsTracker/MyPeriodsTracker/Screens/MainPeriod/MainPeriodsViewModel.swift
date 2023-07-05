//
//  MainPeriodsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 10/06/2023.
//

import Foundation
import SwiftUI

class MainPeriodViewModel: ObservableObject {

	@Published var model: MainPeriodModel
	@AppStorage("PartOfCycle") var partOfCycle: MainPeriodModel.PartOfCycle = .notSet

	@Published var todayDate: Date = Date().midnight

	init() {

		let periodLength = UserDefaults.standard.integer(forKey: "PeriodLength")
		let cycleLength = UserDefaults.standard.integer(forKey: "CycleLength")
		var periodStartDate = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "PeriodStartDate"))

		if periodStartDate.timeIntervalSince1970 == 0 {
			periodStartDate = Date()
		}
		var partOfCycle = MainPeriodModel.PartOfCycle(rawValue: UserDefaults.standard.integer(forKey: "PartOfCycle")) ?? .notSet
		
		let model = MainPeriodModel(periodStartDate: periodStartDate, periodLength: periodLength, cycleLength: cycleLength)
		partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: periodStartDate, periods: periodLength, cycle: cycleLength, partOfCycle: partOfCycle, now: Date().midnight)
		self.partOfCycle = partOfCycle
		self.model = model

		NotificationCenter.default.addObserver(self, selector: #selector(dayDidChange), name: .NSCalendarDayChanged, object: nil)
	}

	func daysLeft() -> Int {
		self.model.daysToPeriod(from: self.todayDate)
	}

	func ovulation() -> Int {
		self.model.getOvulation(self.todayDate)
	}

	func fertility() -> MainPeriodModel.FertilityLevel {
		self.model.getFertility(self.todayDate)
	}

	func nextPeriodDate() -> String {
		DateToStringService.shared.dateAndWeekString(from: self.model.nextPeriodStartDate(now: self.todayDate))
	}

	func endOfPeriodDate() -> String {
		DateToStringService.shared.dateAndWeekString(from: self.model.endOfPeriodDate(now: self.todayDate))
	}

	func dayOfPeriod() -> Int {
		self.model.daysToPeriod(from: self.todayDate)
	}

	func delay() -> Int {
		DateCalculatorService.shared.delay(periodStartDate: self.model.periodStartDate, cycleLength: self.model.cycleLength, now: self.todayDate)
	}

	func showOffPeriodButton() -> Bool {
		let showEarlyStartButtonDay = Calendar.current.date(byAdding: .day, value: -8, to: self.model.nextPeriodStartDate(now: self.todayDate))!
		if todayDate < showEarlyStartButtonDay {
			return false
		}
		return true
	}

	@objc
	func dayDidChange() {
		DispatchQueue.main.async {
			self.todayDate = Date().midnight
		}
	}
}
