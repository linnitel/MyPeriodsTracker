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

	var todayDate: Date {
		Date()
	}

	init() {
		self.model = MainPeriodModel(periodStartDate: Date().addingTimeInterval(-24 * 10 * 60 * 60), periodLength: 5, cycleLength: 30, partOfCycle: .notSet)
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
