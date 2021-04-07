//
//  Data.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation

struct Data {
  static let sampleDrugBank = [
    Drug(generic: "Losartan"),
    Drug(generic: "Lisinopril"),
    Drug(generic: "Simvastatin"),
    Drug(generic: "Metformin"),
    Drug(generic: "Atorvastatin"),
    Drug(generic: "Levothyroxine"),
    Drug(generic: "Amoxicillin"),
    Drug(generic: "Fluoxetine"),
    Drug(generic: "Omeprazole"),
    Drug(generic: "Escitalopram"),
    Drug(generic: "Citalopram"),
    Drug(generic: "Ibuprofen"),
    Drug(generic: "Hydrochlorothiazide"),
    Drug(generic: "Acetaminophen"),
    Drug(generic: "Amlodipine"),
    
    // Test Drugs (Invalid drugs for RxCui request)
    Drug(generic: "XLosartan"),
    Drug(generic: "XLisinopril")
  ]
}
