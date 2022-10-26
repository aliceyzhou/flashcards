//
//  AddViewController.swift
//  ZhouAliceHW6
//
//  Created by alice on 10/20/22.
//

import UIKit

class AddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

//    @IBOutlet weak var questionTextField: UITextView!
//    @IBOutlet weak var answerTextField: UITextField!
//    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var questionTextField: UITextView!
    
    var completion: (() -> Void)?
    var favorite = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTextField.delegate = self
        answerTextField.delegate = self
        questionTextField.becomeFirstResponder()
        saveButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func favoriteSwitched(_ sender: UISwitch) {
        if favoriteSwitch.isOn {
            favorite = true
        }
        else {
            favorite = false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isEnabled = !questionTextField.text!.isEmpty && !answerTextField.text!.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = !questionTextField.text!.isEmpty && !answerTextField.text!.isEmpty
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        questionTextField.resignFirstResponder()
        answerTextField.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        questionTextField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

            if text == "\n" {
                textView.resignFirstResponder()
                answerTextField.becomeFirstResponder()
                return false
            }
            return true
        }
    
    @IBAction func donePressed(_ sender: UITextField) {
        answerTextField.resignFirstResponder()
    }
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        questionTextField.text = ""
        answerTextField.text = ""
        
        dismiss(animated: true)
        completion?()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let question = questionTextField.text, let answer = answerTextField.text else {
            return
        }
        
        if FlashcardModel.sharedInstance.checkAskedQuestion(potentialQuestion: question) {
            
            let alert = UIAlertController(title: "Question already exists!", message: "try again :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            questionTextField.text = ""
            answerTextField.text = ""
            return
        }
        
        if question == "" || answer == "" {
            return
        }
        let card = Flashcard(question: question, answer: answer, isFavorite: favorite)
        FlashcardModel.sharedInstance.insert(card: card)
        
        dismiss(animated: true)
        completion?()
        
    }

    
    
}
