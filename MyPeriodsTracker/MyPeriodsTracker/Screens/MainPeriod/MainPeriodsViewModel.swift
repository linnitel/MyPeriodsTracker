//
//  MainPeriodsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 10/06/2023.
//

import Foundation
import SwiftUI
import os

class MainPeriodViewModel: ObservableObject {

	let logger = Logger (subsystem: "Reddy", category: "mainScreen")

	@AppStorage("NotificationsActive") var notificationsActive: Bool = false
	@AppStorage("NotificationsTime") var notificationTime: Double = 0.0
	@AppStorage("OneDayBeforePeriod") var oneDayBefore: Bool = false
	@AppStorage("StartOfPeriod") var startOfPeriod: Bool = false
	@AppStorage("Ovulation") var ovulationNotif: Bool = false

	let notifications = Notifications()

	@Published var model: MainPeriodModel {
		didSet {
			if self.notificationsActive {
				self.notifications.schaduleNotifications(
					now: Date().midnight,
					startDate: self.model.periodStartDate,
					cycle: self.model.cycleLength,
					time: Date(timeIntervalSince1970: self.notificationTime),
					ovulation: self.ovulationNotif,
					oneDayBefore: self.oneDayBefore,
					startOfPeriod: self.startOfPeriod)
			}
		}
	}
	@AppStorage("PartOfCycle") var partOfCycle: MainPeriodModel.PartOfCycle = .notSet

	@Published var todayDate: Date = Date().midnight

	init() {

		var periodLength = UserDefaults.standard.integer(forKey: "PeriodLength")
		var cycleLength = UserDefaults.standard.integer(forKey: "CycleLength")
		var periodStartDate = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "PeriodStartDate"))

		var partOfCycle = MainPeriodModel.PartOfCycle(rawValue: UserDefaults.standard.integer(forKey: "PartOfCycle")) ?? .notSet


		let notFirstLaunch = UserDefaults.standard.bool(forKey: "NotFirstLaunch")

		if notFirstLaunch {
			partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: periodStartDate, periods: periodLength, cycle: cycleLength, partOfCycle: partOfCycle, now: Date().midnight)
		} else {
			periodLength = 5
			UserDefaults.standard.set(periodLength, forKey: "PeriodLength")
			cycleLength = 28
			UserDefaults.standard.set(cycleLength, forKey: "CycleLength")
			periodStartDate = Date().midnight
			UserDefaults.standard.set(periodStartDate.timeIntervalSince1970, forKey: "PeriodStartDate")
		}

		self.logger.log("Main period view model initialized with: \nPeriod Start Date: \(periodStartDate), \nPeriod Length: \(periodLength), \nCycle length: \(cycleLength), \nPart of cycle: \(partOfCycle.stringValue)")
		let model = MainPeriodModel(periodStartDate: periodStartDate, periodLength: periodLength, cycleLength: cycleLength)
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
		DateToStringService.shared.dateAndWeekString(from: DateCalculatorService.shared.nextPeriodStartDate(now: self.todayDate, date: self.model.periodStartDate, cycle: self.model.cycleLength))
	}

	func endOfPeriodDate() -> String {
		DateToStringService.shared.dateAndWeekString(from: self.model.endOfPeriodDate(now: self.todayDate))
	}

	func dayOfPeriod() -> Int {
		self.model.dayOfPeriod(from: self.model.periodStartDate, now: self.todayDate)
	}

	func delay() -> Int {
		DateCalculatorService.shared.delay(periodStartDate: self.model.periodStartDate, cycleLength: self.model.cycleLength, now: self.todayDate)
	}

	func showOffPeriodButton() -> Bool {
		let showEarlyStartButtonDay = Calendar.current.date(byAdding: .day, value: -8, to: DateCalculatorService.shared.nextPeriodStartDate(now: self.todayDate, date: self.model.periodStartDate, cycle: self.model.cycleLength))!
		if todayDate < showEarlyStartButtonDay {
			return false
		}
		return true
	}

	@objc
	func dayDidChange() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.logger.log("Day did change")
			self.todayDate = Date().midnight
			let notFirstLaunch = UserDefaults.standard.bool(forKey: "NotFirstLaunch")
			if notFirstLaunch {
				self.partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(
					periodStartDate: self.model.periodStartDate,
					periods: self.model.periodLength,
					cycle: self.model.cycleLength,
					partOfCycle: self.partOfCycle,
					now: self.todayDate
				)
				self.logger.log(level: .default, "Part of cycle updated to: \(self.partOfCycle.stringValue)")
			}
		}
	}
}
