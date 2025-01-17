//
//  MaintenanceViewControllerTests.swift
//  RevisadinhoTests
//
//  Created by Jhennyfer Rodrigues de Oliveira on 22/09/21.
// swiftlint:disable trailing_whitespace

import Foundation
import XCTest
@testable import Revisadinho

class MaintenanceViewControllerTests: XCTestCase {
    
    let sut = MaintenanceViewController()
    
    func test_formatingDateIntoString() {
        let date = Date()
        let calendar = Calendar.current
        let dateModel = DateModel()
        let day =  String(calendar.component(.day, from: date))
        let month =  calendar.component(.month, from: date)
        let year = String(calendar.component(.year, from: date))
        let monthInString = dateModel.convertMonthIntToString(monthInt: month)
        let finalString: String = day + " " + (monthInString ?? "") + ", " + year
        let maintenances = sut.formatDate(date: date)
        XCTAssertTrue(maintenances == finalString)
    }
}
