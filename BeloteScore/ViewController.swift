//
//  ViewController.swift
//  BeloteScore
//
//  Created by Atanas Kurtakov on 2/29/16.
//  Copyright © 2016 Atanas Kurtakov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scoreToAddTeamA: UITextField!
    @IBOutlet weak var scoreToAddTeamB: UITextField!
    @IBOutlet weak var totalScoreTeamA: UITextField!
    @IBOutlet weak var totalScoreTeamB: UITextField!
    @IBOutlet weak var scoreReviewTeamA: UITextView!
    @IBOutlet weak var scoreMatchTeamB: UITextField!
    @IBOutlet weak var scoreMatchTeamA: UITextField!
    @IBOutlet weak var scoreReviewTeamB: UITextView!
    
    weak var activeField: UITextField?
    
    var totalTeamA=0, totalTeamB=0;
    var counterA:UInt8 = 1,counterB:UInt8 = 1;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 55, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func addPointsToTeam(textField: UITextField,var totalTeamScore: Int)->(Int)
    {
        if(textField.text!.isEmpty)
        {
            totalTeamScore+=0;
        }
        else if(Int(textField.text!)>=0)
        {
            
            totalTeamScore+=Int(textField.text!)!;
        }
        else
        {
            let alertController = UIAlertController(title: "Warning", message:
                "Incorrect input!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        textField.resignFirstResponder();
        return totalTeamScore;
    }
    @IBAction func addPoints(sender:AnyObject) {
        totalTeamA = addPointsToTeam(scoreToAddTeamA, totalTeamScore: totalTeamA);
        totalTeamB = addPointsToTeam(scoreToAddTeamB, totalTeamScore: totalTeamB);
        totalScoreTeamA.text = totalTeamA.description;
        totalScoreTeamB.text = totalTeamB.description;
        addToReview(scoreToAddTeamA.text!, textField: scoreReviewTeamA,counter: counterA++);
        addToReview(scoreToAddTeamB.text!, textField: scoreReviewTeamB,counter: counterB++);
        isThereWinner(totalTeamA, totalTeamB: totalTeamB);
        scoreToAddTeamA.text?.removeAll();
        scoreToAddTeamB.text?.removeAll();
        
    }
    func addToReview(var scoreToAdd: String,textField: UITextView,counter: UInt8)->Void
    {
        if(scoreToAdd.isEmpty)
        {
            scoreToAdd = "0";
        }
        
        if(counter % 2 != 0)
        {
            textField.text! += "  " + scoreToAdd + "  ";
        }
        else
        {
            textField.text! += "-   " + scoreToAdd + "\n";
            
        }
        textField.font = UIFont.systemFontOfSize(14.0)
    }
    func isThereWinner(totalTeamA: Int,totalTeamB: Int)->Void
    {
        if(totalTeamA>=151 && totalTeamA > totalTeamB)
        {
            if(scoreMatchTeamA.text!.isEmpty)
            {
                scoreMatchTeamA.text = "1"
                scoreMatchTeamB.text = "0"
            }
            else
            {
                scoreMatchTeamA.text = String(Int(scoreMatchTeamA.text!)! + 1)
            }
            endGameController("Team A wins!")
            
        }
        else if(totalTeamB>=151 && totalTeamA < totalTeamB)
        {
            endGameController("Team B wins!")
        }
    }
    func endGameController(message: String)->Void
    {
        let alertControllerWinner = UIAlertController(title: "Congratulation", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let startNewGameAction = UIAlertAction(title: "StartNewGame", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.scoreToAddTeamA.text?.removeAll()
            self.scoreToAddTeamB.text?.removeAll()
            self.scoreReviewTeamA.text?.removeAll()
            self.scoreReviewTeamB.text?.removeAll()
            self.totalScoreTeamA.text?.removeAll()
            self.totalScoreTeamB.text?.removeAll()
            self.counterA = 1
            self.counterB = 1
            self.totalTeamA = 0
            self.totalTeamB = 0
            
        }
        
        alertControllerWinner.addAction(startNewGameAction)
        alertControllerWinner.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertControllerWinner, animated: true, completion: nil)
        
    }
    
}





