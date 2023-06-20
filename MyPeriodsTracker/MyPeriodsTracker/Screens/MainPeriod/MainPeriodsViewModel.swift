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
		self.model = MainPeriodModel(lastPeriodStartDate: Date().addingTimeInterval(-24 * 10 * 60 * 60), periodLength: 5, cycleLength: 30, partOfCycle: .offPeriod)
	}

	func daysLeft() -> Int {
		self.model.daysToPeriod(from: todayDate)
	}

	func ovulation() -> Int {
		self.model.getOvulation(self.model.lastPeriodStartDate)
	}

	func fertility() -> MainPeriodModel.FertilityLevel {
		self.model.getFertility(self.model.lastPeriodStartDate)
	}

	func nextPeriodDate() -> String {
		DateCalculatiorService.shared.getNextDate(self.model.nextPeriodStartDate)
	}

	func delay() -> Int {
		1
	}

	func isDelay() -> Bool {
		true
	}
}
