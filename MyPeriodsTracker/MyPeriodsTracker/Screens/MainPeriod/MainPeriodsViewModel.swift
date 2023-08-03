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
					startDate: self.model.pastPeriodStartDate,
					cycle: self.model.cycleLength,
					period: self.model.periodLength,
					time: Date(timeIntervalSince1970: self.notificationTime),
					ovulation: self.ovulationNotif,
					oneDayBefore: self.oneDayBefore,
					startOfPeriod: self.startOfPeriod)
			}
		}
	}
//	@AppStorage("PartOfCycle") var partOfCycle: MainPeriodModel.PartOfCycle = .notSet

	@Published var todayDate: Date = Date().midnight

	// Init for the image testing
	init(model: MainPeriodModel) {
		self.model = model
	}

	init() {
		var periodLength = UserProfileService.shared.getPeriod()
		var cycleLength = UserProfileService.shared.getCycle()
		var periodStartDate = UserProfileService.shared.getPastPeriodStartDate()
		var partOfCycle = UserProfileService.shared.getStatus()

		let notFirstLaunch = UserProfileService.shared.getNotFirstLaunch()

		if notFirstLaunch {
			partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: periodStartDate, periods: periodLength, cycle: cycleLength, partOfCycle: partOfCycle, now: Date().midnight)
		} else {
			periodLength = 5
			UserProfileService.shared.setPeriod(periodLength)
			cycleLength = 28
			UserProfileService.shared.setCycle(cycleLength)
			periodStartDate = Date().midnight
			UserProfileService.shared.setPastPeriodStartDate(periodStartDate)
		}

		self.logger.log("Main period view model initialized with: \nPeriod Start Date: \(periodStartDate), \nPeriod Length: \(periodLength), \nCycle length: \(cycleLength), \nPart of cycle: \(partOfCycle.stringValue)")
		let lastPeriodStartDate = DateCalculatorService.shared.updateLastPeriodStartDate(periodStartDate, cycleLength: cycleLength, periodLength: periodLength, now: Date().midnight)
		let model = MainPeriodModel(pastPeriodStartDate: periodStartDate, lastPeriodStartDate: lastPeriodStartDate, periodLength: periodLength, cycleLength: cycleLength, status: partOfCycle)
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
		DateCalculatorService.shared.nextPeriodStartDate(now: self.todayDate, date: self.model.pastPeriodStartDate, cycle: self.model.cycleLength, period: self.model.periodLength).dateAndWeekString
	}

	func endOfPeriodDate() -> String {
		self.model.endOfPeriodDate(now: self.todayDate).dateAndWeekString
	}

	func dayOfPeriod() -> Int {
		self.model.dayOfPeriod(from: self.model.pastPeriodStartDate, now: self.todayDate)
	}

	func delay() -> Int {
		DateCalculatorService.shared.delay(periodStartDate: self.model.pastPeriodStartDate, cycleLength: self.model.cycleLength, period: self.model.periodLength, now: self.todayDate)
	}

	func setStatus(to status: MainPeriodModel.PartOfCycle) {
		self.model.status = status
		UserProfileService.shared.setStatus(status)
	}

	func setPastPeriodStartDate(to date: Date) {
		self.model.pastPeriodStartDate = date
		UserProfileService.shared.setPastPeriodStartDate(date)
	}

	func showOffPeriodButton() -> Bool {
		let showEarlyStartButtonDay = Calendar.current.date(byAdding: .day, value: -8, to: DateCalculatorService.shared.nextPeriodStartDate(now: self.todayDate, date: self.model.pastPeriodStartDate, cycle: self.model.cycleLength, period: self.model.periodLength))!
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
			let notFirstLaunch = UserProfileService.shared.getNotFirstLaunch()
			if notFirstLaunch {
				self.setStatus(to: DateCalculatorService.shared.partOfCycleUpdate(
					periodStartDate: self.model.pastPeriodStartDate,
					periods: self.model.periodLength,
					cycle: self.model.cycleLength,
					partOfCycle: model.status,
					now: self.todayDate
				))
				self.logger.log(level: .default, "Part of cycle updated to: \(self.model.status.stringValue)")
			}
		}
	}
}
