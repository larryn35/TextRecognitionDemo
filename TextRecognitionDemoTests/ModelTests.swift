//
//  ModelTests.swift
//  TextRecognitionDemoTests
//
//  Created by Larry N on 4/5/21.
//

import XCTest
@testable import TextRecognitionDemo

class ModelTests: XCTestCase {
  func testParsingJSONIsWorkingForRxCui() throws {
    let mockRxCuiJSON = MockData.rxCuiJSON.data(using: .utf8)!
    
    let drugID = try JSONDecoder().decode(RxCui.self, from: mockRxCuiJSON)
    XCTAssertNotNil(drugID, "drugID returned nil")
    
    XCTAssertEqual(drugID.id, "36437", "Parsed result did not return 36437 for RxCui")
  }
  
  func testRxCuiURLBuilder() {
    let drug = Drug(generic: "lisinopril/hydrochlorothiazide")
    let url = drug.rxCuiURL
    XCTAssertEqual(url?.absoluteString, MockData.rxCuiURL, "RxCuiURL not constructed correctly")
  }
  
  func testParsingJSONIsWorkingForInteractions() throws {
    let mockInteractionsJSON = MockData.interactionsJSON.data(using: .utf8)!
    
    let interactionsContainer = try JSONDecoder().decode(InteractionsContainer.self, from: mockInteractionsJSON)
    XCTAssertNotNil(interactionsContainer, "interactionsContainer returned nil")
    
    guard let interactions = interactionsContainer.interactions else { return }
    XCTAssertEqual(interactions.count, 3, "Parsed results did not return 3 for interactions count")
    
    let firstInteractionDescription = "The serum concentration of Fluoxetine can be increased when it is combined with Simvastatin."
    XCTAssertEqual(interactions[0].description, firstInteractionDescription, "Parsed results did not return correct description for first interaction")
    
    let thirdInteractionDescription = "The serum concentration of Simvastatin can be increased when it is combined with Escitalopram."
    XCTAssertEqual(interactions[2].description, thirdInteractionDescription, "Parsed results did not return correct description for third interaction")
  }
}
