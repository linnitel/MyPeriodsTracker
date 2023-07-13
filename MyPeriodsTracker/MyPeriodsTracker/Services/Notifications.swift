//
//  Notifications.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 03/07/2023.
//

import Foundation
import UserNotifications
import SwiftUI
import os

class Notifications: NSObject {
	let notificationCenter = UNUserNotificationCenter.current()
	let calendar = Calendar.current
	let dateCalculator = DateCalculatorService.shared
	let logger = Logger (subsystem: "Reddy", category: "NotificationsService")

	func notificationRequest(completion: @escaping (Bool, Error?) -> Void) {

		let options: UNAuthorizationOptions = [.alert, .sound, .badge]

		self.notificationCenter.requestAuthorization(options: options, completionHandler: completion)
	}

	func scheduleOneDayBeforePeriodNotification(for date: Date, at time: Date) {
		self.schaduleNotification(
			for: date,
			at: time,
			with: "Periods are comming.",
			body: "Your next period starts tomorrow.",
			identifier: "LocalOneDayBeforePeriodNotification"
		)
	}

	func scheduleFirstPeriodDayNotification(for date: Date, at time: Date) {
		self.schaduleNotification(
			for: date,
			at: time,
			with: "Periods are here.",
			body: "Today is your first period day.",
			identifier: "LocalFirstPeriodDayNotification"
		)
	}

	func scheduleOvulationDayNotification(for date: Date, at time: Date) {
		self.schaduleNotification(
			for: date,
			at: time,
			with: "Your ovulation is today",
			body: "It is important day for you",
			identifier: "LocalOvulationNotification"
		)
	}

	func schaduleOvulationNotification(now: Date, startDate: Date, cycle: Int, time: Date, ovulation: Bool) {
		if ovulation {
			let date = self.dateCalculator.getOvulationDate(now: Date().midnight, startDate: startDate, cycle: cycle)
			self.scheduleOvulationDayNotification(for: date, at: time)
			self.logger.log("Ovulation notification was schaduled")
		} else {
			self.cancelNotification(with: "LocalOneDayBeforePeriodNotification")
			self.logger.log("Ovulation notification was canceled")
		}
	}

	func schaduleOneDayBeforeNotification(now: Date, startDate: Date, cycle: Int, time: Date, oneDayBefore: Bool) {
		if oneDayBefore {
			let date = self.dateCalculator.calculateOneDayBeforePeriod(now: now, date: startDate, cycle: cycle)
			self.scheduleOneDayBeforePeriodNotification(for: date, at: time)
			self.logger.log("First Period day notification was schaduled")
		} else {
			self.cancelNotification(with: "LocalFirstPeriodDayNotification")
			self.logger.log("First Period day notification was canceled")
		}
	}

	func schadulePeriodFirstDayNotification(now: Date, startDate: Date, cycle: Int, time: Date, startOfPeriod: Bool) {
		if startOfPeriod {
			let date = self.dateCalculator.nextPeriodStartDate(now: now, date: startDate, cycle: cycle)
			self.scheduleFirstPeriodDayNotification(for: date, at: time)
			self.logger.log("Start of Period notification was schaduled")
		} else {
			self.cancelNotification(with: "LocalOvulationNotification")
			self.logger.log("Start of Period notification was canceled")
		}
	}

	func schaduleNotifications(now: Date, startDate: Date, cycle: Int, time: Date, ovulation: Bool, oneDayBefore: Bool, startOfPeriod: Bool) {
		self.schaduleOneDayBeforeNotification(now: now, startDate: startDate, cycle: cycle, time: time, oneDayBefore: oneDayBefore)
		self.schadulePeriodFirstDayNotification(now: now, startDate: startDate, cycle: cycle, time: time, startOfPeriod: startOfPeriod)
		self.schaduleOvulationNotification(now: now, startDate: startDate, cycle: cycle, time: time, ovulation: ovulation)
	}

	private func schaduleNotification(for date: Date, at time: Date, with title: String, body: String, identifier: String) {
		let content = UNMutableNotificationContent() // Содержимое уведомления

		content.title = title
		content.body = body
		content.sound = UNNotificationSound.default
		content.badge = 1

		let dateComponents = self.createDateComponents(from: date, at: time)

		let trigger = createTrigger(for: dateComponents)
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		self.notificationCenter.add(request) { (error) in
			if let error = error {
				self.logger.error("Error \(error.localizedDescription)")
			}
		}
	}

	private func createDateComponents(from date: Date, at time: Date) -> DateComponents {
		var dateComponents = DateComponents()
		dateComponents.calendar = calendar
		dateComponents.day = calendar.component(.day, from: date)
		dateComponents.month = calendar.component(.month, from: date)
		dateComponents.hour = calendar.component(.hour, from: time)
		dateComponents.minute = calendar.component(.minute, from: time)
		return dateComponents
	}

	private func createTrigger(for date: DateComponents) -> UNCalendarNotificationTrigger {
		UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
	}

	func cancelAllNotifications() -> Void {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}

	func cancelNotification(with identifier: String) {
		let center = UNUserNotificationCenter.current()
		center.removePendingNotificationRequests(withIdentifiers: [identifier])
	}
	
}

extension Notifications: UNUserNotificationCenterDelegate {

}
