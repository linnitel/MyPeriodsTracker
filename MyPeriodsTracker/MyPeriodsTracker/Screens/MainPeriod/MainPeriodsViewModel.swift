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
		
		let model = MainPeriodModel(periodStartDate: periodStartDate, periodLength: periodLength, cycleLength: cycleLength, partOfCycle: partOfCycle)
//			periodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(periodStartDate, cycleLength: cycleLength)
		partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: periodStartDate, periods: periodLength, cycle: cycleLength, partOfCycle: partOfCycle)
		self.partOfCycle = partOfCycle
//		let partOfCycle = MainPeriodModel.PartOfCycle(rawValue: UserDefaults.standard.integer(forKey: "PartOfCycle")) ?? .notSet
		self.model = model
//		self.partOfCycle = partOfCycle
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
		DateToStringService.shared.getNextDate(self.model.nextPeriodStartDate)
	}

	func endOfPeriodDate() -> String {
		DateToStringService.shared.getNextDate(self.model.endOfPeriodDate)
	}

	func dayOfPeriod() -> Int {
		self.model.dayOfPeriod
	}

	func delay() -> Int {
		self.model.delay
	}

	func showOffPeriodButton() -> Bool {
		let showEarlyStartButtonDay = Calendar.current.date(byAdding: .day, value: -8, to: self.model.nextPeriodStartDate)!
		if todayDate < showEarlyStartButtonDay {
			return false
		}
		return true
	}

	func startTimer() {
		let midnight = Date().midnight.addingTimeInterval(24 * 60 * 60) // Next midnight
		let timer = Timer(fire: midnight, interval: 24 * 60 * 60, repeats: true) { _ in
			self.updateDate()
		}
		RunLoop.main.add(timer, forMode: .common)
	}

	func updateDate() {
		self.todayDate = Date().midnight
	}
}
