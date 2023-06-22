//
//  NotificationSettingsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 22/06/2023.
//

import Foundation

class NotificationSettingsViewModel: ObservableObject {

	@Published var notificationsActive: Bool
//	@Published var oneDayBefore: Bool
//	@Published var startOfPeriod: Bool
//	@Published var ovulation: Bool

	@Published var notificationsList: [NotificationsList]

	@Published var notificationTime: Date

	init() {
		self.notificationsActive = UserDefaults.standard.bool(forKey: "NotificationsActive")

		let oneDayBefore = UserDefaults.standard.bool(forKey: "OneDayBeforePeriod")
//		self.oneDayBefore = oneDayBefore
		let startOfPeriod = UserDefaults.standard.bool(forKey: "StartOfPeriod")
//		self.startOfPeriod = startOfPeriod
		let ovulation = UserDefaults.standard.bool(forKey: "Ovulation")
//		self.ovulation = ovulation

		self.notificationTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "NotificationsTime"))

		self.notificationsList = [
			NotificationsList(id: "One day before period", key: "OneDayBeforePeriod", subscribe: oneDayBefore),
			NotificationsList(id: "Start of the period", key: "StartOfPeriod", subscribe: startOfPeriod),
			NotificationsList(id: "Ovulation", key: "Ovulation", subscribe: ovulation)
		]
	}

	func notificationsActivate(_ isActive: Bool) -> Void {
		UserDefaults.standard.set(isActive, forKey: "NotificationsActive")
		if isActive {
			print(isActive)
		} else {
			print(isActive)
		}
	}
}
