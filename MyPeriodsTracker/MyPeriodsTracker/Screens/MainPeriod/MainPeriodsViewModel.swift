//
//  MainPeriodsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 10/06/2023.
//

import Foundation

class MainPeriodViewModel: ObservableObject {
	@Published var model: MainPeriodModel
	@Published var todayDate = Date()
//	var columns: [Column] {
//		set {
//			switch model.partOfCycle {
//				case .notSet:
//					self.columns = []
//				case .period, .delay, .offPeriod:
//					self = [Column(name: "", data: <#T##String#>)]
//			}
//		}
//	}

	init() {
		self.model = MainPeriodModel(lastPeriodStartDate: Date().addingTimeInterval(-24 * 2 * 60 * 60), periodLength: 5, cycleLength: 30, partOfCycle: .period)

	}

	func daysLeft() -> Int {
		self.model.daysToPeriod
	}

	func ovulation() -> Int {
		DateCalculatiorService.shared.getOvulation(self.model.lastPeriodStartDate)

	}

	func fertility() -> String {
		"Low"
	}
}
