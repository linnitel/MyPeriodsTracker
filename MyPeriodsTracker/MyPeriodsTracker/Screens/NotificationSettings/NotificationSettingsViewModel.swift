//
//  NotificationSettingsViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 22/06/2023.
//

import Foundation
import UIKit

class NotificationSettingsViewModel: ObservableObject {

	let notifications = Notifications()

	@Published var notificationsActive: Bool = false
	@Published var notificationTime: Date

//	@Published var oneDayBefore: Bool
//	@Published var startOfPeriod: Bool
//	@Published var ovulation: Bool

	@Published var notificationsList: [NotificationsList]

	@Published var isNotFirstTime: Bool

	init() {
		self.isNotFirstTime = UserDefaults.standard.bool(forKey: "IsNotFirstTimeNotification")

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
}
