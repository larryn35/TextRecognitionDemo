//
//  StringExtensionTests.swift
//  TextRecognitionDemoTests
//
//  Created by Larry N on 4/5/21.
//

import XCTest
@testable import TextRecognitionDemo

class StringExtensionTests: XCTestCase {

  func testReturnOnlyLettersMethod() {
    let string1 = "Hello, this is test 1"
    let string2 = " ~ H3L/% - tH!5 is t e s t-2"
    
    XCTAssertEqual(string1.returnOnlyLetters(), "hellothisistest")
    XCTAssertEqual(string2.returnOnlyLetters(), "hlthistest")
  }
  
  func testStartsWithMethod() {
    let string1 = "Metformin"
    let string2 = "acetaminophen"
    
    XCTAssertTrue(string1.startsWith("Met"))
    XCTAssertTrue(string1.startsWith("metform"))
    XCTAssertFalse(string1.startsWith( "metformim"))
    
    XCTAssertTrue(string2.startsWith("AceTAMinoPHEN"))
    XCTAssertFalse(string2.startsWith(" acetaminophen"))
    XCTAssertFalse(string2.startsWith("Met"))
  }
}
