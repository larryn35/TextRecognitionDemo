//
//  ContentVMTests.swift
//  TextRecognitionDemoTests
//
//  Created by Larry N on 4/5/21.
//

import XCTest
@testable import TextRecognitionDemo

class ContentVMTests: XCTestCase {

  func testCleanedResultsPopulatedByRecognizer() {
    let viewModel = ContentViewModel(recognizer: MockRecognizer())
    // Cleaned results before loading image
    XCTAssertTrue(viewModel.cleanedResults.isEmpty,
                  "Cleaned results not empty at start")
    
    // "Image loaded from camera"
    let inputImage = UIImage(systemName: "circle")
    viewModel.loadImage(inputImage)
    
    // Cleaned results after loading image
    XCTAssertFalse(viewModel.cleanedResults.isEmpty,
                  "Cleaned results not populated correctly")
    
    let firstStringFromResults = "onsistent"
    XCTAssertEqual(viewModel.cleanedResults.first!,
                   firstStringFromResults,
                   "First string from results not matching onsistent")
    
    // "states)." is the sixth element from the raw recognizer results, "states" should be the fifth after cleaning and removal of "by"
    let fifthStringFromResults = "states"
    XCTAssertEqual(viewModel.cleanedResults[4],
                   fifthStringFromResults,
                   "Fifth string from results not matching states")
  }
  
  func testDrugMatchesPopulatedByRecognizer() {
    let rawText = ["Metformin", "lis", "SIMVASTATIN", "osartan","(citalopram)","Zocor","  ibup-", "hydrox"]
    let mockRecognizer = MockRecognizer(rawText: rawText)
    let viewModel = ContentViewModel(recognizer: mockRecognizer)
    
    // Drug matches before loading image
    XCTAssertTrue(viewModel.drugMatches.isEmpty,
                  "Cleaned results not empty at start")
    
    // "Image loaded from camera"
    let inputImage = UIImage(systemName: "circle")
    viewModel.loadImage(inputImage)
    
    // Drug matches after loading image - should be [Citalopram, Ibuprofen, Citalopram, Ibuprofen]
    XCTAssertEqual(viewModel.drugMatches.count,
                   4,
                   "Drug matches count does not equal 4")
    
    XCTAssertEqual(viewModel.drugMatches[0].generic,
                   "Citalopram",
                   "Citalopram not matched from raw text")
    
    XCTAssertEqual(viewModel.drugMatches[1].generic,
                   "Ibuprofen",
                   "Ibuprofen not matched from raw text")
    
    XCTAssertEqual(viewModel.drugMatches[2].generic,
                   "Metformin",
                   "Metformin not matched from raw text")
    
    XCTAssertEqual(viewModel.drugMatches[3].generic,
                   "Simvastatin",
                   "Simvastatin not matched from raw text")
  }
  
  func testErrorsWhenRecognizerFails() {
    let viewModel = ContentViewModel(recognizer: MockRecognizer(completeWithFailure: true))

    // Error status before loading image
    XCTAssertFalse(viewModel.showErrorMessage,
                   "showInteractionsMessage not set to false at start")
    
    XCTAssertTrue(viewModel.errorMessage.isEmpty,
                  "errorMessage not blank at start")
    
    // "Image loaded from camera"
    let inputImage = UIImage(systemName: "circle")
    viewModel.loadImage(inputImage)
    
    // Error status after loading image
    XCTAssertTrue(viewModel.showErrorMessage,
                  "showInteractionsMessage not set to true after recognizer completed with failure")
    
    XCTAssertEqual(viewModel.errorMessage,
                   "Failed to process image",
                   "errorMessage not set correctly after recognizer completed with failure")
    
    // Test reset errors
    viewModel.resetErrors()
    
    XCTAssertFalse(viewModel.showErrorMessage,
                   "showInteractionsMessage not reset to false")
    
    XCTAssertEqual(viewModel.errorMessage,
                   "",
                   "errorMessage not reset")
  }
  
  func testErrorsWhenFailToRetrieveInputImage() {
    let viewModel = ContentViewModel(recognizer: MockRecognizer())
    
    // "Image not loaded, inputImage is nil"
    viewModel.loadImage(nil)
    
    // Error status after attempting to load image
    XCTAssertTrue(viewModel.showErrorMessage,
                  "showInteractionsMessage not set to true after attempting to load nil inputImage")
    
    XCTAssertEqual(viewModel.errorMessage,
                   "Failed to get picture from camera",
                   "errorMessage not set correctly after attempting to load nil inputImage")
    
    // Test reset errors
    viewModel.resetErrors()
    
    XCTAssertFalse(viewModel.showErrorMessage,
                   "showInteractionsMessage not reset to false")
    
    XCTAssertEqual(viewModel.errorMessage,
                   "",
                   "errorMessage not reset")
  }
}
