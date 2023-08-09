//
//  MyPeriodTrackerWidget.swift
//  MyPeriodTrackerWidget
//
//  Created by Julia Martcenko on 31/07/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(settings: MainPeriodModel(pastPeriodStartDate: Date().midnight, periodLength: 30, cycleLength: 5, status: .period), date: Date().midnight)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(settings: MainPeriodModel(pastPeriodStartDate: Date().midnight, periodLength: 30, cycleLength: 5, status: .period), date: Date().midnight)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let currentDay = Date().midnight
		let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: currentDay)!

		let settings = UserProfileService.shared.getSettings()

		let entries: [SimpleEntry] = [SimpleEntry(settings: settings, date: currentDay)]

		let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
		completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
	var date: Date

	var numberOfDays: Int?
	var numberOfDaysText: String?
	var nextDate: String?
	var nextDateText: String?
	var ovulation: Int?
	var fertility: MainPeriodModel.FertilityLevel?
	var status: MainPeriodModel.PartOfCycle

	init(settings: MainPeriodModel, date: Date) {
		self.date = date
		self.ovulation = settings.getOvulation(date)
		self.fertility = settings.getFertility(date)
		self.status = settings.status
		switch settings.status {
			case .notSet:
				break
			case .offPeriod:
				self.numberOfDays = settings.daysToPeriod(from: date)
				self.numberOfDaysText = "days until period"
				self.nextDate = DateCalculatorService.shared.nextPeriodStartDate(now: date, date: settings.pastPeriodStartDate, cycle: settings.cycleLength, period: settings.periodLength).dateAndWeekString
				self.nextDateText = "Next period"
			case .period:
				self.numberOfDays = settings.dayOfPeriod(from: settings.pastPeriodStartDate, now: date)
				self.numberOfDaysText = "day of period"
				self.nextDate = settings.endOfPeriodDate(now: date).dateAndWeekString
				self.nextDateText = "End of period"
			case .delay:
				self.numberOfDays = DateCalculatorService.shared.delay(periodStartDate: settings.pastPeriodStartDate, cycleLength: settings.cycleLength, period: settings.periodLength, now: date)
				self.numberOfDaysText = "day of delay"
		}
	}
}

struct MyPeriodTrackerWidgetEntryView: View {
    var entry: Provider.Entry

	@Environment(\.widgetFamily) var family

	@ViewBuilder
    var body: some View {
		switch family {
			case .systemMedium:
				if let numberOfDays = entry.numberOfDays,
				   let numberOfDaysText = entry.numberOfDaysText,
				   let ovulation = entry.ovulation,
				   let fertility = entry.fertility {
					MyPeriodTrackerWidgetMediumView(
						numberOfDays: numberOfDays,
						numberOfDaysText: numberOfDaysText,
						nextDate: entry.nextDate,
						nextDateText: entry.nextDateText,
						ovulation: ovulation,
						fertility: fertility
					)
				} else {
					MyPeriodTrackerWidgetMediumPlaceholderView()
				}
			default:
				if let numberOfDays = entry.numberOfDays,
				   let text = entry.numberOfDaysText {
					MyPeriodTrackerWidgetSmallView(numberOfDays: numberOfDays, text: text)
				} else {
					MyPeriodTrackerWidgetSmallPlaceholderView()
				}
				// TODO: add widget for the notSet state if the date is not set up
				// TODO: think of maybe adding the state when something gone wrong and can't access the data
		}
    }
}

struct MyPeriodTrackerWidget: Widget {
    let kind: String = "MyPeriodTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyPeriodTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
		.supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct MyPeriodTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
		MyPeriodTrackerWidgetEntryView(entry: SimpleEntry(settings: MainPeriodModel(pastPeriodStartDate: Date().midnight, periodLength: 30, cycleLength: 5, status: .period), date: Date().midnight))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
