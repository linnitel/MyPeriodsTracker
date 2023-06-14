//
//  MainPeriodModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 10/06/2023.
//

import Foundation

struct MainPeriodModel {
	let lastPeriodStartDate: Date
	let periodLength: Int
	let cycleLength: Int
	let partOfCycle: PartOfCycle

	var todayDate: Date {
		Date()
	}
	var daysToPeriod: Int {
		22
	}

	enum PartOfCycle: Int, CaseIterable {
		case notSet = 0
		case offPeriod = 1
		case period = 2
		case delay = 3
	}
}

struct Column {
	let name: String
	let data: String
}
