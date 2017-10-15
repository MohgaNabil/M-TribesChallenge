//
//  M_Tribes_ChallengeTests.swift
//  M-Tribes ChallengeTests
//
//  Created by Mohga Nabil on 10/12/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest
@testable import M_Tribes_Challenge

class M_Tribes_ChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchingLocations() {
		let expectation = XCTestExpectation(description: "Fetch Locations")
		
		LocationService.getInstance().getLocations { ( locations, err) in
			XCTAssertNil(err, "service call failed")
			XCTAssertNotNil(locations, "No locations were fetched")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 5.0)
    }
    
}
