//
//  FlashcardsModel.swift
//  ZhouAliceHW5
//
//  Created by alice on 10/4/22.
//

import Foundation

class FlashcardModel: NSObject, FlashcardsDataModel {
    
    private var flashcards = [
        Flashcard(question: "What programming language does ITP 342 teach?", answer: "Swift", isFavorite: false),
        Flashcard(question: "Did Alice spend way too long on this assignment?", answer: "absolutely", isFavorite: true),
        Flashcard(question: "What does USC stand for?", answer: "University of Southern California", isFavorite: false),
        Flashcard(question: "When was USC founded?", answer: "1880", isFavorite: false),
        Flashcard(question: "Who is the president of USC?", answer: "Carol Folt", isFavorite: true),
    ] {
        didSet {
            save()
        }
    }
    
    
    private var currentIndex: Int?
    // var questionDisplayed: Bool //legacy code...
    
    static let sharedInstance = FlashcardModel()
        
    var filePath: URL!
    
    override init() {
        super.init()
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        filePath = documentsUrl.appendingPathComponent("cards.json")
        
        if let loadedCards = load() {
            self.flashcards = loadedCards
        }
        currentIndex = 0
        if numberOfFlashcards() == 0 {
            currentIndex = nil
        }
        // self.questionDisplayed = false
    }
    
    func numberOfFlashcards() -> Int {
        return flashcards.count
    }
    
    func randomFlashcard() -> Flashcard? {
        if flashcards.isEmpty { //there's no flashcards :(
            return nil
        }
        else if flashcards.count == 1 { //there's only this one to return
            return flashcard(at: currentIndex!)
        }
        var randomIndex = currentIndex!
        while randomIndex == currentIndex! { //get a randomIndex that's not the current Index
            randomIndex = Int.random(in: 1..<flashcards.count)
        }
        currentIndex = randomIndex
        return flashcards[randomIndex] //return random within range
    }
    
    func flashcard(at index: Int) -> Flashcard? {
        if index < flashcards.count && index >= 0 { //fixed this!!
            currentIndex = index
            return flashcards[index]
        }
        return nil
    }
    
    func nextFlashcard() -> Flashcard? { //I feel like this already works but I was marked off??
        if let next = currentIndex { //optional binding to unwrap
            if next + 1 < flashcards.count {
                currentIndex! += 1
            }
            else { //it would go out of bounds, wrap around to beginning
                currentIndex = 0
            }
            return flashcards[currentIndex!]
        }
        return nil
    }
    
    func previousFlashcard() -> Flashcard? {
        if let prev = currentIndex { //optional binding to unwrap
            if prev - 1 < 0 { //if prev goes out of bounds, return the last element
                currentIndex! = flashcards.count - 1
            }
            else { //just return the previous one, update currentIndex
                currentIndex! -= 1
            }
            return flashcards[currentIndex!]
        }
        return nil
    }
    
    //RIP old work you won't be missed
//    func insert(question: String, answer: String, favorite: Bool) {
//        flashcards.append(Flashcard(question: question, answer: answer, isFavorite: favorite))
//
//        if flashcards.count == 1 {
//            currentIndex = 0 //it would have been nil before we inserted
//        }
//    }

    //just kidding I still need you here to conform to the protocol 😒
    func insert(question: String, answer: String, favorite: Bool, at index: Int) {
        if index < flashcards.count && index >= 0{ //check it's within range
            flashcards.insert(Flashcard(question: question, answer: answer, isFavorite: favorite), at: index)

            if flashcards.count == 1 {currentIndex = 0} //we just added to an empty array
            else if index <= currentIndex! {
                currentIndex! += 1
            }
        }
        else if index == flashcards.count {
            flashcards.append(Flashcard(question: question, answer: answer, isFavorite: favorite)) //fixed...
        }
    }
    
    func insert(card: Flashcard) {
        flashcards.append(card)
    }
    
    func currentFlashcard() -> Flashcard? {
        if flashcards.isEmpty {
            return nil
        }
        return flashcards[currentIndex!]
    }
    
    //tbh I'm not too sure what's supposed to happen if you remove the current card?
    func removeFlashcard(at index: Int) {
        if index < flashcards.count && index >= 0{ //valid remove index
            flashcards.remove(at: index)
            if index < currentIndex! { //if the index is before currentIndex, subtract 1
                currentIndex! -= 1
            }
        }
        
        if flashcards.isEmpty { //we removed the only one D:
            currentIndex = nil
        }
    }
    
    func toggleFavorite() {
        if let ind = currentIndex {
            flashcards[ind].isFavorite = !flashcards[ind].isFavorite //swap the value
        }
    }
    
    func favoriteFlashcards() -> [Flashcard] {
        var favCards = [Flashcard]()
        for card in flashcards {
            if card.isFavorite {
                favCards.append(card)
            }
        }
        return favCards
    }
    
    //spelled wrong because...
    func rearrageFlashcards(from: Int, to: Int) {
        //stuff
        let temp = flashcards[from]
        flashcards.remove(at: from)
        flashcards.insert(temp, at: to)
        
        if currentIndex! == from {
            currentIndex = to
        }
    }
    
    func checkAskedQuestion(potentialQuestion: String) -> Bool {
        //stuff
        for card in flashcards {
            if card.getQuestion().lowercased() == potentialQuestion.lowercased() {
                return true
            }
        }
        return false
    }
    
    private func load() -> [Flashcard]? {
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: filePath)
            let flashcards = try decoder.decode(Array<Flashcard>.self, from: data)
            return flashcards
        } catch {
            print ("error \(error)")
            return nil
        }
    }
    
    private func save() {
        // Save the list of cards to disk
        
        // Use Codable API to encode our quotes array into JSON (standardized formatted string)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(flashcards)
            let dataString = String(data: data, encoding: .utf8)!
            
            try dataString.write(to: filePath, atomically: true, encoding: .utf8)
            
        } catch {
            print("error \(error)")
        }
        
        //print("\(filePath)")
    }
}
