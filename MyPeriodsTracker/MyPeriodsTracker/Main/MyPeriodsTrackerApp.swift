//
//  MyPeriodsTrackerApp.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI

@main
struct MyPeriodsTrackerApp: App {
    var body: some Scene {
        WindowGroup {
			let mainPeriodViewModel = MainPeriodViewModel()
			MainPeriodsView(viewModel: mainPeriodViewModel)
        }
    }
}
