//
//  MockData.swift
//  TextRecognitionDemo
//
//  Created by Larry N on 4/5/21.
//

import Foundation

struct MockData {
  static let rawTextFromRecognizer = ["onsistent", "power", "required", "by", "individual", "states).", "source.", "Keep", "temperature", "logs", "for", "3", "years", "(or", "VACCINE", "STORAGE", "REQUIREMENTS", "Mest", "vaccines", "are", "stored", "in", "the", "refrigerator", "(between", "36°F", "M", "and", "46°F;,", "or", "2°C", "and", "8°C).", "Vaccines", "that", "should", "be", "stored", "in", "the", "freezer", "(between", "58°F", "and", "+5°F,", "or", "-50°C", "and", "-15°c)", "include:", "varicella", "vaccine,", "Zostavax,", "MMRV", "and", "oral", "cholera", "vaccine.", "s", "MMR", "is", "stored", "either", "in", "the", "refrigerator", "or", "freezer.", "ADC", "SE190-23", "11", "Rx", "only", "AGTICE", "Cs", "va", "af", "lyophllnd", "powder", "and", "ad", "of", "d", "g", "od", "2013-2014", "No", "P", "Ped", "SC", "BEPORE", "UE", "Zoster", "Vaccine", "Recombinant,", "Adjuvanted", "SHINGRIX", "Cartarts", "(10", "doues", "of", "NO", "10Vde", "ctrng", "Aant", "19", "Vals", "cortaring", "yogid", "I", "oner", "afs5r", "ar", "ecOrehA"]
  
  static let rxCuiURL = "https://rxnav.nlm.nih.gov/REST/rxcui.json?name=sertraline"
  
  static let rxCuiJSON = """
    {
      "idGroup": {
        "name": "sertraline",
        "rxnormId": [
          "36437"
        ]
      }
    }
  """
  
  static let interactionsURL = "https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=4493+321988+36567"
  
  static let interactionsJSON = """
    {
      "nlmDisclaimer": "It is not the intention of NLM to provide specific medical advice, but rather to provide users with information to better understand their health and their medications. NLM urges you to consult with a qualified physician for advice about medications.",
      "userInput": {
        "sources": [
          ""
        ],
        "rxcuis": [
          "4493",
          "321988",
          "36567"
        ]
      },
      "fullInteractionTypeGroup": [
        {
          "sourceDisclaimer": "DrugBank is intended for educational and scientific research purposes only and you expressly acknowledge and agree that use of DrugBank is at your sole risk. The accuracy of DrugBank information is not guaranteed and reliance on DrugBank shall be at your sole risk. DrugBank is not intended as a substitute for professional medical advice, diagnosis or treatment..[www.drugbank.ca]",
          "sourceName": "DrugBank",
          "fullInteractionType": [
            {
              "comment": "Drug1 (rxcui = 4493, name = fluoxetine, tty = IN). Drug2 (rxcui = 36567, name = simvastatin, tty = IN). Drug1 is resolved to fluoxetine, Drug2 is resolved to simvastatin and interaction asserted in DrugBank between Fluoxetine and Simvastatin.",
              "minConcept": [
                {
                  "rxcui": "4493",
                  "name": "fluoxetine",
                  "tty": "IN"
                },
                {
                  "rxcui": "36567",
                  "name": "simvastatin",
                  "tty": "IN"
                }
              ],
              "interactionPair": [
                {
                  "interactionConcept": [
                    {
                      "minConceptItem": {
                        "rxcui": "4493",
                        "name": "fluoxetine",
                        "tty": "IN"
                      },
                      "sourceConceptItem": {
                        "id": "DB00472",
                        "name": "Fluoxetine",
                        "url": "http://www.drugbank.ca/drugs/DB00472#interactions"
                      }
                    },
                    {
                      "minConceptItem": {
                        "rxcui": "36567",
                        "name": "simvastatin",
                        "tty": "IN"
                      },
                      "sourceConceptItem": {
                        "id": "DB00641",
                        "name": "Simvastatin",
                        "url": "http://www.drugbank.ca/drugs/DB00641#interactions"
                      }
                    }
                  ],
                  "severity": "N/A",
                  "description": "The serum concentration of Fluoxetine can be increased when it is combined with Simvastatin."
                }
              ]
            },
            {
              "comment": "Drug1 (rxcui = 4493, name = fluoxetine, tty = IN). Drug2 (rxcui = 321988, name = escitalopram, tty = IN). Drug1 is resolved to fluoxetine, Drug2 is resolved to escitalopram and interaction asserted in DrugBank between Fluoxetine and Escitalopram.",
              "minConcept": [
                {
                  "rxcui": "4493",
                  "name": "fluoxetine",
                  "tty": "IN"
                },
                {
                  "rxcui": "321988",
                  "name": "escitalopram",
                  "tty": "IN"
                }
              ],
              "interactionPair": [
                {
                  "interactionConcept": [
                    {
                      "minConceptItem": {
                        "rxcui": "4493",
                        "name": "fluoxetine",
                        "tty": "IN"
                      },
                      "sourceConceptItem": {
                        "id": "DB00472",
                        "name": "Fluoxetine",
                        "url": "http://www.drugbank.ca/drugs/DB00472#interactions"
                      }
                    },
                    {
                      "minConceptItem": {
                        "rxcui": "321988",
                        "name": "escitalopram",
                        "tty": "IN"
                      },
                      "sourceConceptItem": {
                        "id": "DB01175",
                        "name": "Escitalopram",
                        "url": "http://www.drugbank.ca/drugs/DB01175#interactions"
                      }
                    }
                  ],
                  "severity": "N/A",
                  "description": "The risk or severity of serotonin syndrome can be increased when Fluoxetine is combined with Escitalopram."
                }
              ]
            },
            {
              "comment": "Drug1 (rxcui = 36567, name = simvastatin, tty = IN). Drug2 (rxcui = 321988, name = escitalopram, tty = IN). Drug1 is resolved to simvastatin, Drug2 is resolved to escitalopram and interaction asserted in DrugBank between Simvastatin and Escitalopram.",
              "minConcept": [
                {
                  "rxcui": "36567",
                  "name": "simvastatin",
                  "tty": "IN"
                },
                {
                  "rxcui": "321988",
                  "name": "escitalopram",
                  "tty": "IN"
                }
              ],
              "interactionPair": [
                {
                  "interactionConcept": [
                    {
                      "minConceptItem": {
                        "rxcui": "36567",
                        "name": "simvastatin",
                        "tty": "IN"
                      },
                      "sourceConceptItem": {
                        "id": "DB00641",
                        "name": "Simvastatin",
                        "url": "http://www.drugbank.ca/drugs/DB00641#interactions"
                      }
                    },
                    {
                      "minConceptItem": {
                        "rxcui": "321988",
                        "name": "escitalopram",
                        "tty": "IN"
                      },
                      "sourceConceptItem": {
                        "id": "DB01175",
                        "name": "Escitalopram",
                        "url": "http://www.drugbank.ca/drugs/DB01175#interactions"
                      }
                    }
                  ],
                  "severity": "N/A",
                  "description": "The serum concentration of Simvastatin can be increased when it is combined with Escitalopram."
                }
              ]
            }
          ]
        }
      ]
    }
  """
  
  static let extractedDescriptions = ["The serum concentration of Fluoxetine can be increased when it is combined with Simvastatin.", "The risk or severity of serotonin syndrome can be increased when Fluoxetine is combined with Escitalopram.", "The serum concentration of Simvastatin can be increased when it is combined with Escitalopram."]
}
