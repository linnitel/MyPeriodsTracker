//
//  Notifications.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 03/07/2023.
//

import Foundation
import UserNotifications

class Notifications: NSObject {
	let notificationCenter = UNUserNotificationCenter.current()
	let calendar = Calendar.current

	func notificationRequest() {

		let options: UNAuthorizationOptions = [.alert, .sound, .badge]

		self.notificationCenter.requestAuthorization(options: options) { success, error in
			if success {
				print("All set!")
			} else if let error = error {
				print(error.localizedDescription)
			} else {
				print("User didn't allow notifications")
			}
		}
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
				print("Error \(error.localizedDescription)")
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
