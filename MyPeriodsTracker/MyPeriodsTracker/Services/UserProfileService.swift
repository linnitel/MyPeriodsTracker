//
//  UserProfileService.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 03/08/2023.
//

import Foundation
import UIKit

struct UserProfileService {
	static let shared = UserProfileService()

	let defaults = UserDefaults.standard
//	let defaults = UserDefaults(suiteName: "group.myPeriodsTracker")!

	private init() {}

	func setStatus(_ status: MainPeriodModel.PartOfCycle) {
		defaults.set(status.rawValue, forKey: "PartOfCycle")
	}

	func getStatus() -> MainPeriodModel.PartOfCycle {
		let rawValue = defaults.integer(forKey: "PartOfCycle")
		let status = MainPeriodModel.PartOfCycle(rawValue: rawValue) ?? .notSet
		return status
	}

	func setPastPeriodStartDate(_ date: Date) {
		defaults.set(date.timeIntervalSince1970, forKey: "PeriodStartDate")
	}
	func getPastPeriodStartDate() -> Date {
		Date(timeIntervalSince1970: defaults.double(forKey: "PeriodStartDate"))
	}

	func setCycle(_ cycle: Int) {
		defaults.set(cycle, forKey: "CycleLength")
	}
	func getCycle() -> Int {
		defaults.integer(forKey: "CycleLength")
	}

	func setPeriod(_ period: Int) {
		defaults.set(period, forKey: "PeriodLength")
	}
	func getPeriod() -> Int {
		defaults.integer(forKey: "PeriodLength")
	}

	func setSettings(_ model: MainPeriodModel) {
		self.setStatus(model.status)
		self.setPastPeriodStartDate(model.pastPeriodStartDate)
		self.setCycle(model.cycleLength)
		self.setPeriod(model.periodLength)
	}
	func getSettings() -> MainPeriodModel {
		let pastPeriodStartDate = self.getPastPeriodStartDate()
		let status = self.getStatus()
		let period = self.getPeriod()
		let cycle = self.getCycle()

		return MainPeriodModel(
			pastPeriodStartDate: pastPeriodStartDate,
			periodLength: period,
			cycleLength: cycle,
			status: status
		)
	}

	func getNotFirstLaunch() -> Bool {
		defaults.bool(forKey: "NotFirstLaunch")
	}

	func setNotFirstLaunch(to notFirstLaunch: Bool) {
		defaults.set(notFirstLaunch, forKey: "NotFirstLaunch")
	}
	
}
