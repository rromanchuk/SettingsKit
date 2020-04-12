//
//  SettingsKitTests.swift
//  SettingsKit
//
//  Created by Dan Trenz on 9/11/16.
//  Copyright © 2016 Dan Trenz. All rights reserved.
//

import XCTest

@testable import SettingsKit


enum Settings: String, SettingsKit {
    case apiEnvironment, cityState, dateOfBirth, enableAnalytics, encodedString, luckyNumber, socialNetworks
    
}


class SettingsKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescription() {
        Settings.set(.luckyNumber, 23)
        XCTAssertEqual(Settings.luckyNumber.description, "23")
    }
    
    func testSetArray() {
        let identifier = Settings.socialNetworks.rawValue
        let value = [ "facebook", "twitter", "instagram" ]
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.socialNetworks, value)
        
        let result = UserDefaults.standard.array(forKey: identifier) as! [String]
        
        XCTAssertEqual(result, value)
    }
    
    func testSetBool() {
        let identifier = Settings.enableAnalytics.rawValue
        let value = true
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.enableAnalytics, value)
        
        let result = UserDefaults.standard.bool(forKey: identifier)
        
        XCTAssertEqual(result, value)
    }
    
    func testSetData() {
        let identifier = Settings.encodedString.rawValue
        let value = NSData(base64Encoded: "SGVsbG8gV29ybGQ=", options: [])!
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.encodedString, value)
        
        let result = UserDefaults.standard.object(forKey: identifier) as! NSData
        
        XCTAssertEqual(result, value)
    }
    
    func testSetDate() {
        let identifier = Settings.dateOfBirth.rawValue
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd";
        let value = formatter.date(from: "1969-02-26")!
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.dateOfBirth, value)
        
        let result = UserDefaults.standard.object(forKey: identifier) as! Date
        
        XCTAssertEqual(result, value)
    }
    
    func testSetDictionary() {
        let identifier = Settings.cityState.rawValue
        let value = [ "Detroit": "Michigan", "Austin": "Texas", "Chicago": "Illinois" ]
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.cityState, value)
        
        let result = UserDefaults.standard.dictionary(forKey: identifier) as! [String: String]
        
        XCTAssertEqual(result, value)
    }
    
    func testSetInt() {
        let identifier = Settings.luckyNumber.rawValue
        let value = 23
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.luckyNumber, value)
        
        let result = UserDefaults.standard.integer(forKey: identifier)
        
        XCTAssertEqual(result, value)
    }
    
    func testSetString() {
        let identifier = Settings.apiEnvironment.rawValue
        let value = "Staging"
        
        UserDefaults.standard.removeObject(forKey: identifier)
        
        Settings.set(.apiEnvironment, value)
        
        let result = UserDefaults.standard.string(forKey: identifier)
        
        XCTAssertEqual(result, value)
    }
    
    func testGetArray() {
        let identifier = Settings.socialNetworks.rawValue
        let value = [ "facebook", "twitter", "instagram" ]
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.socialNetworks) as! [String]
        
        XCTAssertEqual(result, value)
    }
    
    func testGetBool() {
        let identifier = Settings.enableAnalytics.rawValue
        let value = true
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.enableAnalytics) as! Bool
        
        XCTAssertEqual(result, value)
    }
    
    func testGetData() {
        let identifier = Settings.encodedString.rawValue
        let value = NSData(base64Encoded: "SGVsbG8gV29ybGQ=", options: []) as NSData!
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.encodedString) as! NSData
        
        XCTAssertEqual(result, value)
    }
    
    func testGetDate() {
        let identifier = Settings.dateOfBirth.rawValue
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd";
        let value = formatter.date(from: "1969-02-26")!
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.dateOfBirth) as! Date
        
        XCTAssertEqual(result, value)
    }
    
    func testGetDictionary() {
        let identifier = Settings.cityState.rawValue
        let value = [ "Detroit": "Michigan", "Austin": "Texas", "Chicago": "Illinois" ]
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.cityState) as! [ String: String ]
        
        XCTAssertEqual(result, value)
    }
    
    func testGetInt() {
        let identifier = Settings.luckyNumber.rawValue
        let value = 23
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.luckyNumber) as! Int
        
        XCTAssertEqual(result, value)
    }
    
    func testGetString() {
        let identifier = Settings.apiEnvironment.rawValue
        let value = "Staging"
        
        UserDefaults.standard.set(value, forKey: identifier)
        
        let result = Settings.get(.apiEnvironment) as! String
        
        XCTAssertEqual(result, value)
    }
    
    func testSubscribe() {
        var result = false
        
        UserDefaults.standard.set(false, forKey: Settings.enableAnalytics.rawValue)
        
        let expect = expectation(description: "onChange")
        
        Settings.subscribe(.enableAnalytics) { (newValue) -> Void in
            if let newValue = newValue as? Bool {
                result = newValue
            }
            
            expect.fulfill()
        }
        
        UserDefaults.standard.set(true, forKey: Settings.enableAnalytics.rawValue)
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            XCTAssertEqual(result, true)
        }
    }
    
}
