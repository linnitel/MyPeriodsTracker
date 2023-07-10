//
//  NotificationSettingsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 22/06/2023.
//

import SwiftUI

class NotificationSettingsViewModel: ObservableObject {

	var notifications = Notifications()
	let dateCalculator = DateCalculatorService.shared

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

		self.notificationTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "NotificationsTime"))

		let timeDidSet = UserDefaults.standard.bool(forKey: "NotificationTimeDidSet")
		if !timeDidSet {
			var components = DateComponents()
			components.hour = 12
			components.minute = 0
			self.notificationTime = Calendar.current.date(from: components)!
			UserDefaults.standard.set(self.notificationTime.timeIntervalSince1970, forKey: "NotificationsTime")
			UserDefaults.standard.set(true, forKey: "NotificationTimeDidSet")
		}

		NotificationCenter.default.addObserver(self, selector: #selector(dayDidChange), name: .NSCalendarDayChanged, object: nil)
	}

	func getGlobalNotification(completion: (() -> Void)?) {
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
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
		self.notifications.schaduleOvulationNotification(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle, time: self.notificationTime, ovulation: self.ovulation)
	}

	func schaduleOneDayBeforeNotification() {
		self.notifications.schaduleOneDayBeforeNotification(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle, time: self.notificationTime, oneDayBefore: self.oneDayBefore)
	}

	func schadulePeriodFirstDayNotification() {
		self.notifications.schadulePeriodFirstDayNotification(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle, time: self.notificationTime, startOfPeriod: self.startOfPeriod)
	}

	@objc
	func dayDidChange() {
		let center = UNUserNotificationCenter.current()
		var oneDayBefore = true
		var ovulation = true
		var	firstDay = true

		center.getPendingNotificationRequests { (notifications) in
			print("Count: \(notifications.count)")
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
				time: self.notificationTime,
				ovulation: ovulation && self.ovulation,
				oneDayBefore: oneDayBefore && self.oneDayBefore,
				startOfPeriod: firstDay && self.startOfPeriod
			)
		}

	}
}
