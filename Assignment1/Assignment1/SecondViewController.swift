//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Niamh Gallagher on 18/03/2019.
//  Copyright © 2019 Niamh Gallagher. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    //this is all the variables needed for this view controller
    var titleOf : String = ""
    var authorsOf : String = ""
    var emailOf : String = ""
    var docOf : String = ""
    var pdfLink : URL?
    var toggledFav : Bool = false

    //this is all the connections from the storyboard
    @IBOutlet weak var docTitle: UILabel!
    @IBOutlet weak var docAuthor: UILabel!
    @IBOutlet weak var documentText: UILabel!
    @IBOutlet weak var viewFullPDF: UIButton!
    @IBOutlet weak var emailAuthor: UILabel!
    
    @IBAction func saveFavourite(_ sender: UISwitch) {
        //this checks if the switch is on and changes the boolean accordingly
        if sender.isOn{
            toggledFav = true
        }else{
            toggledFav = false
        }
    }
    @IBAction func viewFullPDF(_ sender: Any) {
        //this opens safari when the view full article button is clicked and shows the article
        UIApplication.shared.open(pdfLink!, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //this sends the favourite info back to the main view controller
        let vc = segue.destination as! ViewController
        vc.isChecked = toggledFav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //declaring the number of lines for each label
        docTitle.numberOfLines = 2
        docAuthor.numberOfLines = 2
        
        //assigning the variables to the labels
        docTitle.text = titleOf
        docAuthor.text = authorsOf
        documentText.text = docOf
        
        //checking to see if there is a link to the full article
        if pdfLink != nil{
            //if there is a link the button is shown
            viewFullPDF.isHidden = false
        }else{
            //if there is no link the button is hidden
            viewFullPDF.isHidden = true
        }
        //checks to see if there is an email provided
        if emailOf != "No email provided"{
            // if there is one the email is displayed
            emailAuthor.isHidden = false
            emailAuthor.text = "Email: " + emailOf
        }else{
            //if there is no email nothing is shown
            emailAuthor.isHidden = true
        }
    }
    

}
