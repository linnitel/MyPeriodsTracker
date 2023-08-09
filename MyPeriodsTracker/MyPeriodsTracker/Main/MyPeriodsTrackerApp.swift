//
//  MyPeriodsTrackerApp.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI
import BackgroundTasks
import WidgetKit

@main
struct MyPeriodsTrackerApp: App {
	@ObservedObject var mainPeriodViewModel = MainPeriodViewModel()
	@Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
			MainPeriodsView(viewModel: mainPeriodViewModel)
				.onChange(of: scenePhase) { newPhase in
					if newPhase == .active {
						UIApplication.shared.applicationIconBadgeNumber = 0
					} else if newPhase == .background {
						WidgetCenter.shared.reloadAllTimelines()
					}
				}
        }
    }
}
