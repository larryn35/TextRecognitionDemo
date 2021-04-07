//
//  InteractionsVMTests.swift
//  TextRecognitionDemoTests
//
//  Created by Larry N on 4/5/21.
//

import XCTest
@testable import TextRecognitionDemo

class InteractionsVMTests: XCTestCase {

  var drugMatches = [Drug(generic: "Losartan"),
                     Drug(generic: "lisinopril/hydrochlorothiazide")]
  
  func testInteractionsURLBuilder() {
    let viewModel = InteractionsViewModel(drugMatches: drugMatches)
    
    let url = viewModel.constructInteractionsURL(with: ["4493", "321988", "36567"])
    XCTAssertEqual(url?.absoluteString, MockData.interactionsURL, "InteractionsURL not constructed correctly")
  }
  
  func testInteractionsPopulatedWithSuccessfulFetch() throws {
    let mockApiService = MockAPIService()
    let mockCombineHelper = MockCombineHelper()
    let viewModel = InteractionsViewModel(
      apiService: mockApiService,
      combineHelper: mockCombineHelper,
      drugMatches: drugMatches
    )
    
    // Interactions array before fetch
    XCTAssertTrue(viewModel.interactions.isEmpty, "Interactions not loaded")

    // Fetch
    viewModel.fetchInteractions()
    
    // Interactions array after fetch
    XCTAssertFalse(viewModel.interactions.isEmpty, "Interactions not loaded")
    XCTAssertEqual(viewModel.interactions.count, 3,"Incorrect number of interactions loaded")
    
    let descriptions = viewModel.interactions.map { $0.description }
    
    XCTAssertEqual(descriptions.sorted(), MockData.extractedDescriptions.sorted())
  }
  
  func testSearchCompleteSetToTrueAfterSuccessfulFetch() throws {
    let mockApiService = MockAPIService()
    let mockCombineHelper = MockCombineHelper()
    let viewModel = InteractionsViewModel(
      apiService: mockApiService,
      combineHelper: mockCombineHelper,
      drugMatches: drugMatches
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch
    viewModel.fetchInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after fetch")
  }
  
  func testErrorsWhenMergeRequestsReturnsWithOneMissedDrug() {
    let mockCombineHelper = MockCombineHelper(completionArray: ["1","2","3"])
    let viewModel = InteractionsViewModel(
      combineHelper: mockCombineHelper,
      drugMatches: [Drug(generic: "1"),
                    Drug(generic: "2"),
                    Drug(generic: "3"),
                    Drug(generic: "4")]
    )
    
    // Error status before fetch
    XCTAssertEqual(viewModel.errorMessage, "", "Error message not blank at start")
    XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage not set to false at start")
    
    // Fetch completes with empty array
    viewModel.fetchInteractions()
    
    // Error status following fetch
    XCTAssertEqual(viewModel.errorMessage,
                   "Important: A drug from the list was not included in the check due to an error. This list may not include all possible interactions.",
                   "Error message not set correctly after merge failure")
    XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage not set to true following merge failure")
  }
  
  func testErrorsWhenMergeRequestsReturnsWithMultipleMissedDrugs() {
    let mockCombineHelper = MockCombineHelper(completionArray: ["1","2","3"])
    let viewModel = InteractionsViewModel(
      combineHelper: mockCombineHelper,
      drugMatches: [Drug(generic: "1"),
                    Drug(generic: "2"),
                    Drug(generic: "3"),
                    Drug(generic: "4"),
                    Drug(generic: "5")]
    )
    
    // Error status before fetch
    XCTAssertEqual(viewModel.errorMessage, "", "Error message not blank at start")
    XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage not set to false at start")
    
    // Fetch completes with empty array
    viewModel.fetchInteractions()
    
    // Error status following fetch
    XCTAssertEqual(viewModel.errorMessage,
                   "Important: 2 drugs from the list were not included in the check due to an error. This list may not include all possible interactions.",
                   "Error message not set correctly after merge failure")
    XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage not set to true following merge failure")
  }
  
  func testSearchCompleteSetToTrueAfterMergeMissesDrugs() throws {
    let mockCombineHelper = MockCombineHelper(completionArray: ["1","2","3"])
    let viewModel = InteractionsViewModel(
      combineHelper: mockCombineHelper,
      drugMatches: [Drug(generic: "1"),
                    Drug(generic: "2"),
                    Drug(generic: "3"),
                    Drug(generic: "4"),
                    Drug(generic: "5")]
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch completes with empty array
    viewModel.fetchInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after merge failed")
  }
  
  func testErrorsWhenMergeRequestsReturnsEmptyArray() {
    let mockCombineHelper = MockCombineHelper(completionArray: [])
    let viewModel = InteractionsViewModel(
      combineHelper: mockCombineHelper,
      drugMatches: drugMatches
    )
    
    // Error status before fetch
    XCTAssertEqual(viewModel.errorMessage, "", "Error message not blank at start")
    XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage not set to false at start")
    
    // Fetch completes with empty array
    viewModel.fetchInteractions()
    
    // Error status following fetch
    XCTAssertEqual(viewModel.errorMessage, "Error: Unable to get information for drugs", "Error message not set correctly after merge failure")
    XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage not set to true following merge failure")
  }
  
  func testSearchCompleteSetToTrueAfterFailedMerge() throws {
    let mockCombineHelper = MockCombineHelper(completionArray: [])
    let viewModel = InteractionsViewModel(
      combineHelper: mockCombineHelper,
      drugMatches: drugMatches
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch completes with empty array
    viewModel.fetchInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after merge failed")
  }
  
  func testErrorsWhenJSONRequestFails() {
    let mockApiService = MockAPIService(getJSONCompletedWithFailure: true)
    let mockCombineHelper = MockCombineHelper()
    let viewModel = InteractionsViewModel(
      apiService: mockApiService,
      combineHelper: mockCombineHelper,
      drugMatches: drugMatches
    )
    
    // Error status before fetch
    XCTAssertEqual(viewModel.errorMessage, "", "Error message not blank at start")
    XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage not set to false at start")
    
    // Fetch ending in getJSON failure
    viewModel.fetchInteractions()
    
    // Error status following fetch
    XCTAssertEqual(viewModel.errorMessage, "Error: Unable to get interactions from URL", "Error message not set correctly after getJSON failure")
    XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage not set to true following getJSON failure")
  }
  
  func testSearchCompleteSetToTrueAfterGetJSONFail() throws {
    let mockApiService = MockAPIService(getJSONCompletedWithFailure: true)
    let mockCombineHelper = MockCombineHelper()
    let viewModel = InteractionsViewModel(
      apiService: mockApiService,
      combineHelper: mockCombineHelper,
      drugMatches: drugMatches
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch ending in getJSON failure
    viewModel.fetchInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after fetch")
  }
}
