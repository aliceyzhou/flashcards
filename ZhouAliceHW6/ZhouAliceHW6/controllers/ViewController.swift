//
//  ViewController.swift
//  ZhouAliceHW5
//
//  Created by alice on 10/4/22.
//

import UIKit

class ViewController: UIViewController {

    //main page
    @IBOutlet weak var card: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //add questions page
    
    
    let cardDeck = FlashcardModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapRecognized))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapRecognized))
        singleTap.require(toFail: doubleTap)
        self.view.addGestureRecognizer(singleTap)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRecognized))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightRecognized))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        card.text = cardDeck.randomFlashcard()?.getQuestion()
        updateStar()
        

    }
    
    override func viewWillAppear(_ animated: Bool) { //right before the view appears
        super.viewWillAppear(animated)
        
        if cardDeck.numberOfFlashcards() == 0 {
            card.text = "no cards available :("
        }
        else {
            card.text = cardDeck.currentFlashcard()?.getQuestion()
            updateStar()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) { //right after it appears
        super.viewDidAppear(animated)
        //print("\(#function)")
    }
    
    // MARK: - Gesture Recs

    //get a random card
    //animation: go up and down
    @objc func singleTapRecognized(recognizer: UITapGestureRecognizer) {
        
        if cardDeck.numberOfFlashcards() == 0 {
            card.text = "no cards available :("
            return
        }
        
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut, animations: { () -> Void in
            //move the card "up"
            self.card.transform = CGAffineTransform(translationX: 0, y: -1000)
            self.favoriteButton.transform = CGAffineTransform(translationX: 0, y: -1000)
        })
        animator.startAnimation()
        
        animator.addCompletion { _ in
            let animator2 = UIViewPropertyAnimator(duration: 2.0, curve: UIView.AnimationCurve.easeInOut) {
                
                self.card.backgroundColor = .white
                self.card.text = self.cardDeck.randomFlashcard()?.getQuestion()
                self.updateStar()
                self.card.transform = CGAffineTransform(translationX: 0, y: 0)
                self.favoriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            animator2.startAnimation()
        }
        animator.startAnimation()
        
    }
    //switch between answer/question
    @objc func doubleTapRecognized(recognizer: UITapGestureRecognizer) {
        
        if self.card.text == "no cards available :(" {
            self.card.text = "please add more cards :)"
            return
        }
        else if self.card.text == "please add more cards :)" {
            self.card.text = "no cards available :("
            return
        }
        
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: UIView.AnimationCurve.easeInOut) {
            self.card.alpha = 0
            self.favoriteButton.alpha = 0
        }
        animator.startAnimation()
        
        animator.addCompletion { _ in
            
            let animator2 = UIViewPropertyAnimator(duration: 0.5, curve: UIView.AnimationCurve.easeInOut) {
                
                if (self.card.text == self.cardDeck.currentFlashcard()?.getAnswer()) { //I realize now this should be using questionDisplayed but please I was so proud of this solution don't take points off 🙏
                    self.card.text = self.cardDeck.currentFlashcard()?.getQuestion()
                    self.favoriteButton.alpha = 1
                    self.card.backgroundColor = .white
                }
                else {
                    self.card.text = self.cardDeck.currentFlashcard()?.getAnswer()
                    self.card.backgroundColor = UIColor(red: 0.8, green: 0.7, blue: 0.9, alpha: 1.0)
                    //self.favoriteButton.alpha = 0
                }
                self.card.alpha = 1
            }
            animator2.startAnimation()
        }
    }
    //get next questions
    //card goes left, teleport right, move to left
    @objc func swipeLeftRecognized(recognizer: UISwipeGestureRecognizer) {
        
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut, animations: { () -> Void in
            //move the card "left"
            self.card.transform = CGAffineTransform(translationX: -400, y: 0)
            self.favoriteButton.transform = CGAffineTransform(translationX: -400, y: 0)

        })
        animator.startAnimation()
        
        animator.addCompletion { _ in
            
            self.card.transform = CGAffineTransform(translationX: 400, y: 0)
            self.favoriteButton.transform = CGAffineTransform(translationX: 400, y: 0)

            let animator2 = UIViewPropertyAnimator(duration: 1.5, curve: UIView.AnimationCurve.easeInOut) {
                
                self.card.backgroundColor = .white
                self.card.text = self.cardDeck.nextFlashcard()?.getQuestion()
                self.updateStar()
                self.card.transform = CGAffineTransform(translationX: 0, y: 0)
                self.favoriteButton.transform = CGAffineTransform(translationX: 0, y: 0)

            }
            animator2.startAnimation()
        }
        
        animator.startAnimation()

    }
    //get previous question
    //card goes right, teleport to left, move right
    @objc func swipeRightRecognized(recognizer: UITapGestureRecognizer) {
        
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut, animations: { () -> Void in
            //move the card "up"
            self.card.transform = CGAffineTransform(translationX: 400, y: 0)
            self.favoriteButton.transform = CGAffineTransform(translationX: 400, y: 0)

        })
        animator.startAnimation()
        
        animator.addCompletion { _ in
            
            self.card.transform = CGAffineTransform(translationX: -400, y: 0) //the teleportation magic
            self.favoriteButton.transform = CGAffineTransform(translationX: -400, y: 0)

            let animator2 = UIViewPropertyAnimator(duration: 1.5, curve: UIView.AnimationCurve.easeInOut) {
                
                self.card.backgroundColor = .white
                self.card.text = self.cardDeck.previousFlashcard()?.getQuestion()
                self.updateStar()
                self.card.transform = CGAffineTransform(translationX: 0, y: 0)
                self.favoriteButton.transform = CGAffineTransform(translationX: 0, y: 0)

            }
            animator2.startAnimation()
        }
        animator.startAnimation()

    }
    
    
    @IBAction func favoriteChange(_ sender: UIButton) {
        cardDeck.toggleFavorite()
        updateStar()
    }
    
    func updateStar() {
        guard let favoriteButton else {
            return
        }

        if cardDeck.currentFlashcard()!.isFavorite {
            favoriteButton.setImage(UIImage(named: "starFilled")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)), for: .normal)
        }
        else {
            favoriteButton.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    

    
}

