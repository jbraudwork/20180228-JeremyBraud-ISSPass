//
//  ISS_PassesTests.swift
//  ISS PassesTests
//
//  Created by Jeremy Braud on 2/19/18.
//  Copyright © 2018 JPMC. All rights reserved.
//

import XCTest
@testable import ISS_Passes

class ISS_PassesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiAvailability() {
        guard let apiUrl = URL(string: Url.getIssPasses+"lat=30&lon=30") else { return }
        let promise = expectation(description: "Simple Request")
        URLSession.shared.dataTask(with: apiUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let result = json as? NSDictionary {
                    XCTAssertTrue(result["message"] as! String == "success")
                    promise.fulfill()
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
