//
//  NotificationSettingsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 22/06/2023.
//

import SwiftUI

class NotificationSettingsViewModel: ObservableObject {

	let notifications = Notifications()
	let dateCalculator = DateCalculatorService.shared

	let periodStartDate: Date
	let cycle: Int
	let period: Int

	@Published var globalNotificationsActive: Bool = false
	@AppStorage("NotificationsActive") var notificationsActive: Bool = false
	@Published var notificationTime: Date

	@AppStorage("OneDayBeforePeriod") var oneDayBefore: Bool = false
	@AppStorage("StartOfPeriod") var startOfPeriod: Bool = false
	@AppStorage("Ovulation") var ovulation: Bool = false

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
		if self.ovulation {
			let date = self.dateCalculator.getOvulationDate(now: Date().midnight, startDate: self.periodStartDate, cycle: self.cycle)
			self.notifications.scheduleOvulationDayNotification(for: date, at: self.notificationTime)
		} else {
			self.notifications.cancelNotification(with: "LocalOneDayBeforePeriodNotification")
		}
	}

	func schaduleOneDayBeforeNotification() {
		if self.oneDayBefore {
			let date = self.dateCalculator.calculateOneDayBeforePeriod(now: Date().midnight, date: self.periodStartDate, cycle: self.cycle)
			self.notifications.scheduleOneDayBeforePeriodNotification(for: date, at: self.notificationTime)
		} else {
			self.notifications.cancelNotification(with: "LocalFirstPeriodDayNotification")
		}
	}

	func schadulePeriodFirstDayNotification() {
		if self.startOfPeriod {
			let date = self.dateCalculator.nextPeriodStartDate(now: Date().midnight, date: self.periodStartDate, cycle: self.cycle)
			self.notifications.scheduleFirstPeriodDayNotification(for: date, at: self.notificationTime)
		} else {
			self.notifications.cancelNotification(with: "LocalOvulationNotification")
		}
	}

	@objc
	func dayDidChange() {
		DispatchQueue.main.async {
			self.schaduleNotifications()
		}
	}
}
