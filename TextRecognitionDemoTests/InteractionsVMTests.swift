//
//  InteractionsVMTests.swift
//  TextRecognitionDemoTests
//
//  Created by Larry N on 4/5/21.
//

import XCTest
@testable import TextRecognitionDemo

class InteractionsVMTests: XCTestCase {
  var drugMatches = ["Lisinopril", "Losartan"]
  
  func testRxCuiURLBuilder() {
    let apiService = MockAPIService()
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: drugMatches
    )
    
    let url = viewModel.constructRxCuiURL(for: "sertraline")
    XCTAssertEqual(url?.absoluteString, MockData.rxCuiURL, "RxCuiURL not constructed correctly")
  }
  
  func testInteractionsURLBuilder() {
    let apiService = MockAPIService()
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: drugMatches
    )
    
    let url = viewModel.constructInteractionsURL(with: ["4493", "321988", "36567"])
    XCTAssertEqual(url?.absoluteString, MockData.interactionsURL, "InteractionsURL not constructed correctly")
  }
  
  func testInteractionsPopulatedWithSuccessfulFetch() throws {
    let apiService = MockAPIService()
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: drugMatches
    )
    
    // Interactions array before fetch
    XCTAssertTrue(viewModel.interactions.isEmpty, "Interactions not loaded")

    // Fetch
    viewModel.fetchDrugIDsAndInteractions()
    
    // Interactions array after fetch
    XCTAssertFalse(viewModel.interactions.isEmpty, "Interactions not loaded")
    XCTAssertEqual(viewModel.interactions.count, 3,"Incorrect number of interactions loaded")
    
    let descriptions = viewModel.interactions.map { $0.description }
    
    XCTAssertEqual(descriptions.sorted(), MockData.extractedDescriptions.sorted())
  }
  
  func testSearchCompleteSetToTrueAfterSuccessfulFetch() throws {
    let apiService = MockAPIService()
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: drugMatches
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch
    viewModel.fetchDrugIDsAndInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after fetch")

  }
  
  func testErrorsWhenMergeRequestsFails() {
    let apiService = MockAPIService(mergeRequestCompleteWithFailure: true)
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: [""]
    )
    
    // Error status before fetch
    XCTAssertEqual(viewModel.errorMessage, "", "Error message not blank at start")
    XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage not set to false at start")
    
    // Fetch ending in merge failure
    viewModel.fetchDrugIDsAndInteractions()
    
    // Error stats following fetch
    XCTAssertEqual(viewModel.errorMessage, "Error merging requests", "Error message not set correctly after merge failure")
    XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage not set to true following merge failure")
  }
  
  func testSearchCompleteSetToTrueAfterFailedMerge() throws {
    let apiService = MockAPIService(mergeRequestCompleteWithFailure: true)
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: [""]
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch ending in merge failure
    viewModel.fetchDrugIDsAndInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after merge failed")
  }
  
  func testErrorsWhenJSONRequestFails() {
    let apiService = MockAPIService(getJSONCompletedWithFailure: true)
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: [""]
    )
    
    // Error status before fetch
    XCTAssertEqual(viewModel.errorMessage, "", "Error message not blank at start")
    XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage not set to false at start")
    
    // Fetch ending in getJSON failure
    viewModel.fetchDrugIDsAndInteractions()
    
    // Error stats following fetch
    XCTAssertEqual(viewModel.errorMessage, "Error checking for interactions", "Error message not set correctly after getJSON failure")
    XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage not set to true following getJSON failure")
  }
  
  func testSearchCompleteSetToTrueAfterGetJSONFail() throws {
    let apiService = MockAPIService(getJSONCompletedWithFailure: true)
    let viewModel = InteractionsViewModel(
      apiService: apiService,
      drugMatches: drugMatches
    )
    
    // isSearchComplete before fetch
    XCTAssertFalse(viewModel.isSearchComplete, "isSearchComplete not set to false at start")

    // Fetch ending in getJSON failure
    viewModel.fetchDrugIDsAndInteractions()
    
    // isSearchComplete after fetch
    XCTAssertTrue(viewModel.isSearchComplete, "isSearchComplete not set to true after fetch")
  }
}
