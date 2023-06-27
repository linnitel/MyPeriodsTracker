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

	@AppStorage("PartOfCycle") var partOfCycle: Int = MainPeriodModel.PartOfCycle.notSet.rawValue
//	@AppStorage("cycleLength") var cycle: Int = 0
//	@AppStorage("periodLength") var period: Int = 0
//	@AppStorage("periodStartDate") var periodStartDat: Date = Date()

	var todayDate: Date {
		Date()
	}

	init() {
		let periodLength = UserDefaults.standard.integer(forKey: "PeriodLength")
		let cycleLength = UserDefaults.standard.integer(forKey: "CycleLength")
		var periodStartDate = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "PeriodStartDate"))
		if periodStartDate.timeIntervalSince1970 == 0 {
			periodStartDate = Date()
		}
//		let partOfCycle = MainPeriodModel.PartOfCycle(rawValue: UserDefaults.standard.integer(forKey: "PartOfCycle")) ?? .notSet
		self.model = MainPeriodModel(periodStartDate: periodStartDate, periodLength: periodLength, cycleLength: cycleLength, partOfCycle: .notSet)
//		self.partOfCycle = partOfCycle
	}

	func daysLeft() -> Int {
		self.model.daysToPeriod(from: self.todayDate)
	}

	func ovulation() -> Int {
		self.model.getOvulation()
	}

	func fertility() -> MainPeriodModel.FertilityLevel {
		self.model.getFertility()
	}

	func nextPeriodDate() -> String {
		DateCalculatiorService.shared.getNextDate(self.model.nextPeriodStartDate)
	}

	func endOfPeriodDate() -> String {
		DateCalculatiorService.shared.getNextDate(self.model.endOfPeriodDate)
	}

	func dayOfPeriod() -> Int {
		self.model.dayOfPeriod
	}

	func delay() -> Int {
		self.model.delay
	}

	func early() -> Int {
		self.model.early
	}

	func upperButtonAction() -> Void {
		switch self.model.partOfCycle {
			case .delay:
				print("recalculate")
			case .early:
				print("recalculate")
			case .period:
				print("")
			case .notSet, .offPeriod:
				break
		}
	}
}
