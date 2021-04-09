![](https://github.com/larryn35/TextRecognitionDemo/blob/main/ReadMeResources/Screenshots.png?raw=true)

## About the app

An iOS app that allows you to search for drugs using text recognition and check for interactions. Built with SwiftUI and Google's ML Kit. The drug interaction data is from the National Library of Medicine (NLM)'s [Drug Interaction API](https://rxnav.nlm.nih.gov/InteractionAPIs.html). This is a simplified and slimmed-down version of an intern project (demo can be seen [here](https://larryn35.github.io/otherprojects.html)), and the number of drugs that this version can recognize is limited to these [15 drugs](https://github.com/larryn35/TextRecognitionDemo/blob/main/TextRecognitionDemo/Data/Drugbank.swift). If you have any questions about either version, I would be happy to try to answer them.
<br><br>

### ML Kit Vision

ML Kit Vision is a set of APIs that allows you to incorporate features, such as barcode scanning, face detection, image labelling, and text recognition, into your mobile app. For text recognition, setup was pretty simple and the performance was fairly accurate. The [guide](https://developers.google.com/ml-kit/vision/text-recognition/ios) outlines how to install the library, how to run the recognizer in your code, and provides some tips to improve accuracy.

To allow users to take photos using their phone camera, create an [ImagePicker](https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller) and update the project's `Info.plist` by adding `Privacy - Camera Usage Description` for the key and a reason for using the camera as the value. 

I created a file called `RecognizerService` and imported `UIKit` and `MLKit`. Inside of a `RecognizerService` struct, I proceeded to include the code from the guide into a `scanText(from image: UIImage)` method I created. 

Note: Step 1 of the guide did mislabel their `image` property as shown below:

```swift
// From the Vision guide

let image = VisionImage(image: UIImage) // Should be "let visionImage = VisionImage..."
visionImage.orientation = image.imageOrientation
```

The recognizer can return the text by blocks, lines, and individual words ([example](https://developers.google.com/ml-kit/vision/text-recognition)). With this app, I was just interested in getting back each word. This was what my `RecognizerService` file looked like at this point:

```swift
import UIKit
import MLKit

struct RecognizerService {
  
  func scanText(from image: UIImage, completion: @escaping (Result<[String],RecognizerError>) -> Void) {
    var results = [String]()
    
    let visionImage = VisionImage(image: image)
    visionImage.orientation = image.imageOrientation
    
    let textRecognizer = TextRecognizer.textRecognizer()
    
    textRecognizer.process(visionImage) { result, error in
      guard error == nil, let result = result else {
        // Error handling
        completion(.failure(.error("Failed to process image")))
        return
      }
      // Recognized text
      for block in result.blocks {
        for line in block.lines {
          for element in line.elements {
            let elementText = element.text
            results.append(elementText)
          }
        }
      }
      completion(.success(results))
    }
  }
}
```

From here, you would take the UIImage returned from the ImagePicker when the user takes a photo and pass that image into the `scanText` method to get your results.
<br><br>

### Cleaning data and matching to drug database 

![](https://github.com/larryn35/TextRecognitionDemo/blob/main/ReadMeResources/Photo-Example.jpeg?raw=true)

Here are the elements that the recognizer returns for the picture above:

```swift
// Results from recognizer: 

["onsistent", "power", "required", "by", "individual", "states).", "source.", "Keep", "temperature", "logs", "for", "3", "years", "(or", "VACCINE", "STORAGE", "REQUIREMENTS", "Mest", "vaccines", "are", "stored", "in", "the", "refrigerator", "(between", "36°F", "M", "and", "46°F;,", "or", "2°C", "and", "8°C).", "Vaccines", "that", "should", "be", "stored", "in", "the", "freezer", "(between", "58°F", "and", "+5°F,", "or", "-50°C", "and", "-15°c)", "include:", "varicella", "vaccine,", "Zostavax,", "MMRV", "and", "oral", "cholera", "vaccine.", "s", "MMR", "is", "stored", "either", "in", "the", "refrigerator", "or", "freezer.", "ADC", "SE190-23", "11", "Rx", "only", "AGTICE", "Cs", "va", "af", "lyophllnd", "powder", "and", "ad", "of", "d", "g", "od", "2013-2014", "No", "P", "Ped", "SC", "BEPORE", "UE", "Zoster", "Vaccine", "Recombinant,", "Adjuvanted", "SHINGRIX", "Cartarts", "(10", "doues", "of", "NO", "10Vde", "ctrng", "Aant", "19", "Vals", "cortaring", "yogid", "I", "oner", "afs5r", "ar", "ecOrehA"]
```

<br>
There are some errors present (such as "Mest" instead of "Most", and "58°F" instead of "-58°F"), especially when trying to read text from the Shingrix packaging at the bottom of the image, but Vision does a pretty good job overall at accurately reading printed text. 

To pull drugs from the list of results, I looped through my drugbank and checked if each drug contains a match from the results, To reduce the number of false matches, I filtered the results beforehand. There are many ways to go about this and I'm sure there is a better method than what I have, but this was what I came up with:

```swift
extension String {
  // Remove non-letter characters from string
  func returnOnlyLetters() -> String {
    let acceptedChars = Set("abcdefghijklmnopqrstuvwxyz")
    return self.lowercased().filter { acceptedChars.contains($0) }
  }
}
```

```swift
extension ContentViewModel {
  // Returns array of strings containing just letters and at least 4 characters long
  private func cleanData(for results: [String], minCharactersPerResult: Int = 4) -> [String] {
    let formattedStrings = results.map { $0.returnOnlyLetters() }
    let meetsCharacterLimit = formattedStrings.filter { $0.count >= minCharactersPerResult }
    return meetsCharacterLimit
  }
}
```

Applying these methods to the results above yields the following:

```swift
// Cleaned results from recognizer

["onsistent", "power", "required", "individual", "states", "source", "keep", "temperature", "logs", "years", "vaccine", "storage", "requirements", "mest", "vaccines", "stored", "refrigerator", "between", "vaccines", "that", "should", "stored", "freezer", "between", "include", "varicella", "vaccine", "zostavax", "mmrv", "oral", "cholera", "vaccine", "stored", "either", "refrigerator", "freezer", "only", "agtice", "lyophllnd", "powder", "bepore", "zoster", "vaccine", "recombinant", "adjuvanted", "shingrix", "cartarts", "doues", "ctrng", "aant", "vals", "cortaring", "yogid", "oner", "afsr", "ecoreha"]
```

<br>

To find the potential drug matches, I checked if each drug from the drug bank started with any of the text from the cleaned results. 

```swift
extension String {
  func returnOnlyLetters() -> String {
    // [...]
  }

  // Checks if string starts with an inputted string regardless of case
  // Ex. "metformin".startsWith("MET") = true
  func startsWith(_ string: String) -> Bool {
    return self.range(of: "^\(string)", options: [.caseInsensitive, .regularExpression]) != nil
  }
}
```

```swift
extension ContentViewModel {
  private func cleanData(for results: [String], minCharactersPerResult: Int = 4) -> [String] {
    // [...]
  }
  
  // Returns drugs from drugbank whose prefix is equal to a string from the cleaned results
  private func findMatches(results: [String]) -> [Drug] {
    var drugMatchesSet = Set<Drug>()
    for drug in Drugbank.drugs {
      for result in results {
        if drug.generic.startsWith(result) {
          drugMatchesSet.insert(drug)
        }
      }
    }
    let sortedArray = Array(drugMatchesSet).sorted()
    return sortedArray
  }
}
```

You may want to adjust your filtering and matching process depending on how you set up your drug bank and how sensitive you want your matches to be.  My view model looked like this after adding the methods.

```swift
final class ContentViewModel: ObservableObject {
  @Published var image: Image?
  @Published var drugMatches = [Drug]()

  let recognizer = RecognizerService()
  
  // Load image from Camera into recognizer
	func loadImage(_ inputImage: UIImage?) {
    guard let inputImage = inputImage else { return }
    image = Image(uiImage: inputImage)
    
    recognizer.scanText(from: inputImage) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let results):
        let cleanedData = self.cleanData(for: results)
        self.cleanedResults = cleanedData
        
        let matches = self.findMatches(results: cleanedData)
        
        for drug in matches {
          if !self.drugMatches.contains(drug) {  // Ensure duplicates aren't added
            self.drugMatches.append(drug)
          }
        }
        
      case .failure:
       // [,,,] Handle error
      }
    }
  }
}

```

In the view, you would call `loadImage()` when the `ImagePicker` sheet is dismissed. 

```swift
struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()
  @State private var inputImage: UIImage?
  @State private var showingImagePicker = false
  
  var body: some View {
    VStack {
      Button("Take photo") {
        showingImagePicker = true
      }
      
      List(viewModel.drugMatches, id: \.self) { drug in
        Text(drug.generic)
      }
    }
    .sheet(isPresented: $showingImagePicker, onDismiss: viewModel.loadImage(inputImage)) {
      ImagePicker(image: $inputImage)
    }
  }
}
```

That's pretty much gist of it for Vision and the text recognition portion. I changed the `ContentView` of this app to allow you to see your photo, the results from the recognizer post-cleaning and filtering, and the drug matches. For this simplified app, the `Drugbank.drugs` is an array of `Drug` objects representing the following generic drugs:

```swift
"Losartan", "Lisinopril", "Simvastatin", "Metformin", "Atorvastatin", "Levothyroxine", "Amoxicillin", "Fluoxetine", "Omeprazole", "Escitalopram", "Citalopram", "Ibuprofen", "Hydrochlorothiazide", "Acetaminophen", and "Amlodipine"
```

<br>
This app will only present matches that come from this list, but feel free to modify the list however you would like. 
<br><br>

### Networking

Compared to my [basketball stats app](https://github.com/larryn35/BasketballStats), working with [Drug Interaction API](https://rxnav.nlm.nih.gov/InteractionAPIs.html) was a little more challenging. The API has a [findInteractionsFromList](https://rxnav.nlm.nih.gov/api-Interaction.findInteractionsFromList.html) function that accepts  a list of RxNorm identifiers (RxCUI), which represents each drug in their database. As a result, I had to use the [findRxcuiByString](https://rxnav.nlm.nih.gov/api-RxNorm.findRxcuiByString.html) from the [RxNorm API](https://rxnav.nlm.nih.gov/RxNormAPIs.html) to get the RxCUI ID for each drug and combine them into a string before using the Drug Interaction API. 

For retrieving the RxCUI for each drug, I added this method to my `InteractionsViewModel` class:

```swift
import Foundation
import Combine

final class InteractionsViewModel: ObservableObject {
  @Published var missedDrugs = [String]()

  func createIDRequest(for drug: Drug) -> AnyPublisher<String, Never> {
    // Drug objects have a computed property that creates a URL for fetching the RxCui
    guard let url = drug.rxCuiURL else {
      return Just("").eraseToAnyPublisher()
    }
    
    let request = URLRequest(url: url)
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: RxCui.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .compactMap { $0.id } // Get id from RxCui
      .catch { [weak self] error -> Just<String> in
        self?.missedDrugs.append(drug.generic) // Track drugs that fail request
        return Just("") // Return empty string
      }
      .eraseToAnyPublisher()
  }
}
```

The findRxcuiByString function has a search parameter that allows for finding results that are similar to the drug that we insert. For example, "lisinopril/hydrochlorothiazide", "hydrochlorothiazide - lisinopril", "hctz lisinopril" would all fetch the same RxCUI. But in the event where the function fails to recognize the drug name that is passed in (maybe due to a typo, or the drug hasn't been added to the API yet), we can catch the error, add the drug to a `missedDrugs` array, and return an empty string that will be filtered out later. This allows the interaction check to continue with the drugs that successfully retrieved a RxCUI, and for me to track and alert the user of the drugs that aren't included.

In a `CombineHelper` class, I added a helper method that ensure that each request has been completed before passing all of the RxCUIs to the next function. This function will also remove any blank strings, (`""`), which represents a request error from `createIDRequest(for drug:)`,

```swift
final class CombineHelper: CombineHelperProtocol {
  private var cancellables = Set<AnyCancellable>()
  
  func mergeRequests(_ requests:  [AnyPublisher<String, Never>], completion: @escaping ([String]) -> Void) {
    Publishers.MergeMany(requests)
      .filter { $0 != "" }
      .collect()
      .sink { _ in
      } receiveValue: { ids in
        completion(ids)
      }
      .store(in: &cancellables)
  }
}
```

Putting it all together, I created a `fetchInteractions` method that will be called when my `InteractionsView` appears.

```swift
extension InteractionsViewModel {
  
  func fetchInteractions() {
    let drugMatchesCount = drugMatches.count 
    // Number of drugs user wants to check for interactions with
 
    let requests = drugMatches.map { createIDRequest(for: $0) }
    
    combineHelper.mergeRequests(requests) { [weak self] drugIDs in
      if drugIDs.isEmpty {
        // [...] Failed to fetch RxCUI for any of the drugs, alert user
        return
      }
      
      self?.drugsChecked = drugIDs.count
			// Number of drugs with a RxCUI retrieved
      
      if drugMatchesCount > drugIDs.count {
        let drugsMissing = drugMatchesCount - drugIDs.count
        // [...] Alert user that there are drugs are not included in interactions list
      }
      
      self?.fetchJSON(for: drugIDs)
    }
  }
  
  private func fetchJSON(for ids: [String]) {
    let url = constructInteractionsURL(with: ids) 
    // Joins array of RxCuis into a string and inserts into a URL to fetch the interactions
    
    guard let wrappedURL = url else { return }
    
    apiService.getJSON(url: wrappedURL) { [weak self] (result: Result<InteractionsContainer, APIError>) in
      switch result {
      case .success(let fetched):
        guard let fetchedInteractions = fetched.interactions else { 
          // [...] Alert user that drugs selected do not interact with each other
          return 
        }
        // [...] Update view with interactions

      case .failure(let error):
        // [...] Alert user of networking/decoding error
        }
      }
    }
  }
}
```

If you plan to this API, make sure to include the following disclaimer somewhere in your app:

> ### "This product uses publicly available data from the U.S. National Library of Medicine (NLM), National Institutes of Health, Department of Health and Human Services; NLM is not responsible for the product and does not endorse or recommend this or any other product."
>
> <br>

## Closing thoughts

- This was a fun project to get familiar with ML Kit Vision and Optical Character Recognition (OCR). With how easy and straight-forward using the text recognition API was, I would be interested in exploring the rest of ML Kit's APIs or Apple's own Vision framework.

- The toughest parts of creating the app were data cleaning, drug matching, and using the drug interactions API. 

- As someone who is still learning how to use Combine and write more testable code, I am not extremely confident in my code for the networking portion. While the app appears to be working as intended and I didn't find any memory leaks when testing with the memory graph and Instruments, I'm sure there are better and cleaner ways to structure my code. I would love to know what problems can arise or any suggestions on how to improve this or any other part of the app.

- While the NLM's Drug Interaction API have the advantages of being free, is updated monthly, and can check up to 50 drugs at a time, the following make it tough to recommend using this app over others for checking drug interactions:
  - Lack of severity indicator for interactions
  - Description of interactions can sometimes be vague or not patient-friendly
  - Some of the interactions provided are more theoretical than clinically significant
    <br><br>

## Other resources

- [Leonardo Souza - Using Combine's MergeMany to fulfill your requests](https://leonardo-matos.medium.com/using-combines-mergemany-to-fulfill-your-requests-99e652b89cbf)
- [Stewart Lynch - Enums for Multiple sheets (Youtube)](https://www.youtube.com/watch?v=7dZfpAn_P2g) 
- [Paul Hudson - How to create scrolling pages of content using tabViewStyle()](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-scrolling-pages-of-content-using-tabviewstyle) 
- [SwiftWithMajid - Menus in SwiftUI](https://swiftwithmajid.com/2020/08/05/menus-in-swiftui/)
- [unDraw - Open source illustrations for any idea](https://undraw.co) (used in Pyrls Vision app)
