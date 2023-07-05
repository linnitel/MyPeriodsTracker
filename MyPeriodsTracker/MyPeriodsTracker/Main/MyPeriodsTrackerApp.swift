//
//  MyPeriodsTrackerApp.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI
import BackgroundTasks

@main
struct MyPeriodsTrackerApp: App {
	@ObservedObject var mainPeriodViewModel = MainPeriodViewModel()

    var body: some Scene {
        WindowGroup {
			MainPeriodsView(viewModel: mainPeriodViewModel)
        }
    }
}
