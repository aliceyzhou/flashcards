//
//  ZhouAliceHW5Tests.swift
//  ZhouAliceHW5Tests
//
//  Created by alice on 10/4/22.
//

import XCTest
@testable import ZhouAliceHW6

class ZhouAliceHW6Tests: XCTestCase {
    var cardDeck: FlashcardModel!

    override func setUp() {
        cardDeck = FlashcardModel() //this should be calling init and all that right
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Begin self tests:
    
    func testSharedModel() {
        let model1 = FlashcardModel.sharedInstance
        let model2 = FlashcardModel.sharedInstance
     // modify model1 and check if model2 has this modification
        
        model1.removeFlashcard(at: 3)
        let numIn1 = model1.numberOfFlashcards()
        let numIn2 = model2.numberOfFlashcards()
        
        XCTAssertEqual(numIn1, numIn2)
    }
    
    func testNumberOfFlashcards() {
        let num = cardDeck.numberOfFlashcards()
        cardDeck.removeFlashcard(at: 2)
        cardDeck.removeFlashcard(at: 2)
        let num2 = cardDeck.numberOfFlashcards()
        
        XCTAssert(num2 == num - 2)
        
    }
    
    func testRandomFlashcard() {
        //idea...just do random a bunch of times to prove it's not just the same card every time?
        for _ in 1...50 {
            let start = cardDeck.currentFlashcard()
            let rand = cardDeck.randomFlashcard()
            XCTAssert(start != rand)
        }
    }
    
    func testFlashcard() {
        //test that it gets normally, won't crash on nil
        let workingCard = cardDeck.flashcard(at: 0)
        XCTAssert(workingCard?.getAnswer() == "Swift")
        
        let nilCard = cardDeck.flashcard(at: 10)
        XCTAssertNil(nilCard, "hehe")
    }
    
    func testNextFlashcard() {
        var card1 = cardDeck.flashcard(at: 1) //theoretically, this moves internal index to i
        card1 = cardDeck.nextFlashcard() //internally moves the index to i + 1
        let card2 = cardDeck.flashcard(at: 2)

        XCTAssertEqual(card1, card2) //check whether they're actually the same??
    }
    
//    func testNextFlashcard2() {
//        let card = Flashcard(question: "hello", answer: "there", isFavorite: true)
//        cardDeck.insert(question: "hello", answer: "there", favorite: true, at: 0)
//        cardDeck.flashcard(at: cardDeck.numberOfFlashcards() - 1) //change index
//
//        let cardNext = cardDeck.nextFlashcard()
//        XCTAssert(card == cardNext)
//    }
    
    func testNextFlashcard3() {
        let card0 = cardDeck.flashcard(at: 0)
        for _ in 1...4 {
            _ = cardDeck.nextFlashcard()
        }
        XCTAssertEqual(cardDeck.nextFlashcard(), card0)
    }
    
    func testPreviousFlashcard() {
        //test norm cases:
        for i in 1...4 {
            var card1 = cardDeck.flashcard(at: i) //theoretically, this moves internal index to i
            card1 = cardDeck.previousFlashcard() //internally moves the index to i + 1
            let card2 = cardDeck.flashcard(at: i-1)
        
            XCTAssert(card1 == card2)
        }
        
        //test bound case: prev of 0 should be the last card
        var card1 = cardDeck.flashcard(at: 0)
        card1 = cardDeck.previousFlashcard()
        let card2 = cardDeck.flashcard(at: cardDeck.numberOfFlashcards() - 1)
        XCTAssert(card1 == card2)
        
        
    }
    
//    func testInsert() {
//        let originalSize = cardDeck.numberOfFlashcards()
//        cardDeck.insert(question: "testQ", answer: "testA", favorite: true)
//        let afterSize = cardDeck.numberOfFlashcards()
//
//        XCTAssert(originalSize + 1 == afterSize) //see if insert succesful
//        XCTAssert(cardDeck.flashcard(at: afterSize - 1)?.getAnswer() == "testA") //see if actually inserted correctly at end
//
//    }
    
    func testInsertAt() {
        let originalSize = cardDeck.numberOfFlashcards()
        cardDeck.insert(question: "testQ", answer: "testA", favorite: true, at: 3)
        let afterSize = cardDeck.numberOfFlashcards()
        
        XCTAssert(originalSize + 1 == afterSize) //see if insert succesful
        XCTAssert(cardDeck.flashcard(at: 3)?.getAnswer() == "testA") //see if actually inserted correctly
        
    }
    
    func testCurrentFlashcard() {
        let card1 = cardDeck.flashcard(at: 3)
        let card2 = cardDeck.currentFlashcard()
        
        XCTAssert(card1 == card2)
        
        //remove all the cards, test again
        while cardDeck.numberOfFlashcards() > 0 {
            cardDeck.removeFlashcard(at: 0)
        }
        
        XCTAssertNil(cardDeck.currentFlashcard())
    }
    
    func testRemoveFlashcard() {
        let original4 = cardDeck.flashcard(at: 4)
        
        let originalSize = cardDeck.numberOfFlashcards()
        cardDeck.removeFlashcard(at: 2)
        let afterSize = cardDeck.numberOfFlashcards()
        
        let after3 = cardDeck.flashcard(at: 3) //since we removed 2, everything else should be moved up one
        
        XCTAssert(originalSize - 1 == afterSize) //see if remove succesful
        XCTAssertEqual(original4, after3)
    }
    
    func testToggleFavorite() {
        
        let before = cardDeck.currentFlashcard()?.isFavorite
        cardDeck.toggleFavorite()
        XCTAssert(cardDeck.currentFlashcard()?.isFavorite != before)
        
    }
    
    func testFavoriteFlashcards() {
        //manually count the number of favorite cards, see if it's the same as what function gives
        var counter:Int = 0
        for i in 0...cardDeck.numberOfFlashcards()-1 {
            if ((cardDeck.flashcard(at: i)?.isFavorite)!) {
                counter += 1
            }
        }
        
        XCTAssert(cardDeck.favoriteFlashcards().count == counter)
    }

}
