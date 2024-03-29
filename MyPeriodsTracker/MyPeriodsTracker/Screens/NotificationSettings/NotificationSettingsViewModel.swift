//
//  NotificationSettingsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 22/06/2023.
//

import SwiftUI
import os

class NotificationSettingsViewModel: ObservableObject {

	var notifications = Notifications()
	let dateCalculator = DateCalculatorService.shared
	let logger = Logger (subsystem: "Reddy", category: "NotificationsView")

	let periodStartDate: Date
	let cycle: Int
	let period: Int

	@Published var globalNotificationsActive: Bool = false

	@AppStorage("NotificationsActive") var notificationsActive: Bool = false

	@AppStorage("OneDayBeforePeriod") var oneDayBefore: Bool = false
	@AppStorage("StartOfPeriod") var startOfPeriod: Bool = false
	@AppStorage("Ovulation") var ovulation: Bool = false

	@Published var notificationTime: Date

	@AppStorage("IsNotFirstTimeNotification") var isNotFirstTime: Bool = false

	init(periodStartDate: Date, cycle: Int, period: Int) {
		self.periodStartDate = periodStartDate
		self.cycle = cycle
		self.period = period

		self.notificationTime = UserProfileService.shared.getNotificationsTime()

		let timeDidSet = UserProfileService.shared.getNotificationTimeDidSet()
		if !timeDidSet {
			var components = DateComponents()
			components.hour = 12
			components.minute = 0
			self.notificationTime = Calendar.current.date(from: components)!
			UserProfileService.shared.setNotificationsTime(self.notificationTime)
			UserProfileService.shared.setNotificationTimeDidSet(true)
			self.logger.log("The defalt value of notification time was set up")
		}

		self.logger.log("Notifications were initialized with: \nPeriod start date: \(periodStartDate),\nCycle length: \(cycle),\nPeriod: \(period)")
		self.logger.log("Notifications are active = \(self.notificationsActive)")

		NotificationCenter.default.addObserver(self, selector: #selector(dayDidChange), name: .NSCalendarDayChanged, object: nil)
	}

	func getGlobalNotification(completion: (() -> Void)?) {
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			self.logger.log("Global notifications were requested, settings status is \(settings.authorizationStatus.rawValue)")
			DispatchQueue.main.async {
				switch settings.authorizationStatus {
					case .notDetermined, .denied, .provisional, .ephemeral:
						self.globalNotificationsActive = false
					case .authorized:
						self.globalNotificationsActive = true
					@unknown default:
						self.globalNotificationsActive = false
				}
				completion?()
			}
		}
	}

	func schaduleNotifications() {
		self.schaduleOneDayBeforeNotification()
		self.schadulePeriodFirstDayNotification()
		self.schaduleOvulationNotification()
	}

	func schaduleOvulationNotification() {
		if self.notificationsActive {
			self.notifications.schaduleOvulationNotification(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle, period: self.period, time: self.notificationTime, ovulation: self.ovulation)
		}
	}

	func schaduleOneDayBeforeNotification() {
		if self.notificationsActive {
			self.notifications.schaduleOneDayBeforeNotification(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle, period: self.period, time: self.notificationTime, oneDayBefore: self.oneDayBefore)
		}
	}

	func schadulePeriodFirstDayNotification() {
		if self.notificationsActive {
			self.notifications.schadulePeriodFirstDayNotification(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle, period: self.period, time: self.notificationTime, startOfPeriod: self.startOfPeriod)
		}
	}

	@objc
	func dayDidChange() {
		let center = UNUserNotificationCenter.current()
		var oneDayBefore = true
		var ovulation = true
		var	firstDay = true

		center.getPendingNotificationRequests { (notifications) in
			self.logger.log("Active notifications Count: \(notifications.count)")
			for item in notifications {
				if item.identifier == "LocalOneDayBeforePeriodNotification" {
					oneDayBefore = false
				} else if item.identifier == "LocalFirstPeriodDayNotification" {
					firstDay = false
				} else if item.identifier == "LocalOvulationNotification" {
					ovulation = false
				}
			}
			self.notifications.schaduleNotifications(
				now: Date().midnight,
				startDate: self.periodStartDate,
				cycle: self.cycle,
				period: self.period,
				time: self.notificationTime,
				ovulation: ovulation && self.ovulation,
				oneDayBefore: oneDayBefore && self.oneDayBefore,
				startOfPeriod: firstDay && self.startOfPeriod
			)
			self.logger.log("Notifications were reschaduled for future cycle")
		}

	}
}
