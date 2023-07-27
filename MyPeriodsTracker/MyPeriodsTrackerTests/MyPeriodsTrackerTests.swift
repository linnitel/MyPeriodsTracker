//
//  MyPeriodsTrackerTests.swift
//  MyPeriodsTrackerTests
//
//  Created by Julia Martcenko on 26/07/2023.
//

import XCTest
@testable import MyPeriodsTracker

final class MyPeriodsTrackerTests: XCTestCase {

	let now = Date(fromString: "2023.07.26")!.midnight
	let period = 5
	let cycle = 30

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testIsPeriodPartOfCycleRemoteStartingDate() throws {

		let startDateString = Date(fromString: "2023.05.25")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .period)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

	func testIsPeriodPartOfCycleCloseStartingDate() throws {

		let startDateString = Date(fromString: "2023.07.25")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .period)
	}

	func testIsPeriodPartOfCycleFirstDate() throws {

		let startDateString = Date(fromString: "2023.06.26")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .period)
	}

	func testIsPeriodPartOfCycleSecondDate() throws {

		let startDateString = Date(fromString: "2023.06.25")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .period)
	}

	func testIsPeriodPartOfCycleLastDate() throws {

		let startDateString = Date(fromString: "2023.06.21")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .offPeriod)
	}

	func testIsOffPeriodPartOfCycleFirstDate() throws {

		let startDateString = Date(fromString: "2023.06.20")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .offPeriod)
	}

	func testIsOffPeriodPartOfCycleRemoteStartingDate() throws {

		let startDateString = Date(fromString: "2023.05.15")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .offPeriod)
	}

	func testIsOffPeriodPartOfCycleCloseStartingDate() throws {

		let startDateString = Date(fromString: "2023.06.27")!

		let partOfCycle: MainPeriodModel.PartOfCycle = .notSet

		let calculatedPartOfCycle = DateCalculatorService.shared.partOfCycleUpdate(periodStartDate: startDateString, periods: period, cycle: cycle, partOfCycle: partOfCycle, now: now)

		XCTAssertTrue(calculatedPartOfCycle == .offPeriod)
	}

	
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
