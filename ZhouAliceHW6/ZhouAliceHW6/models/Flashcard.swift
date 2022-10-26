//
//  Flashcard.swift
//  ZhouAliceHW5
//
//  Created by alice on 10/4/22.
//

import Foundation

struct Flashcard:Equatable, Codable {
    private var question: String
    private var answer: String
    
    public var isFavorite: Bool
    
    init(question: String, answer: String, isFavorite: Bool=false) {
        self.question = question
        self.answer = answer
        self.isFavorite = isFavorite
    }
    
    func getQuestion() -> String {
        return question
    }
    
    func getAnswer() -> String {
        return answer
    }
}
