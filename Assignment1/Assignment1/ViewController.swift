//
//  ViewController.swift
//  Assignment1
//
//  Created by Niamh Gallagher on 11/03/2019.
//  Copyright © 2019 Niamh Gallagher. All rights reserved.
//

import UIKit

//this is all the JSON code
struct techReport: Decodable {
    let year: String
    let id: String
    let owner: String?
    let email: String?
    let authors: String
    let title: String
    let abstract: String?
    let pdf: URL?
    let comment: String?
    let lastModified: String
}

struct technicalReports: Decodable {
    let techreports2: [techReport]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //initalising the tableview and the cells
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myCell: UITableView!
    
    //this is all the variables needed for the view controller
    var list = [techReport]() //I use this to access all the JSON information
    var headNames: [String] = [""]
    var documentsTitle: [[String]] = [[]] //all of these arrays are used to section off
    var documentsAuthor: [[String]] = [[]] //all the information into their years
    var documentsContent: [[String]] = [[]]
    var documentsEmail: [[String]] = [[]]
    var documentsURL: [[URL?]] = [[]]
    var cellRow:Int = 0 //both these variables are used to remember which cell has
    var cellSection:Int = 0 //been clicked so i can access it
    var isChecked:Bool = false //to check if it is a favourite or not
    
    func loadJson(){
        
        /* All this code is being used to access and sort the JSON data and add it to my list array
         * the list is then sorted from the most recent to the least recent and then all the years
         * are found and added to an array and then the documents are grouped into which section they
         * need to be added to */
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, err) in
                
                guard let jsonData = data else { return }
                
                do{
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(technicalReports.self, from: jsonData)
                    self.list = reportList.techreports2
                    self.sortList()
                    self.getHeader()
                    self.groupDocs()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                } catch let jsonErr {
                    
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
            
        }
        
    }
    
    func sortList(){
        /* this is a short method which sorts everything by
         * the year, decending */
        list.sort(by: {$0.year > $1.year})
    }
    
    func getHeader(){
        /* in this method i sort through the json data looking at
         * the years and finding which ones have documents*/
        for i in 0..<list.count {
            //if the year isnt already in the array it is added
            if (headNames.contains(list[i].year)){}
            else{
                headNames.append(list[i].year)
            }
        }
    }
    
    func groupDocs(){
        /* in this method i use my 2D arrays to group all the
         * documents by their years */
        for i in 0..<headNames.count{
            //for every new year a new array is created
            documentsTitle.append([])
            documentsAuthor.append([])
            documentsContent.append([])
            documentsEmail.append([])
            documentsURL.append([])
            for j in 0..<list.count{
                /* then if the current document is the same year as where
                 * we are it is added to that section */
                //i also check if the current one is empty to avoid run time errors
                if(list[j].year == headNames[i]){
                    documentsTitle[i].append(list[j].title)
                    documentsAuthor[i].append(list[j].authors)
                    if list[j].abstract != nil {
                        documentsContent[i].append(list[j].abstract!)
                    }else{
                        documentsContent[i].append("No Abstract Given")
                    }
                    if list[j].email != nil {
                        documentsEmail[i].append(list[j].email!)
                    }else{
                        documentsEmail[i].append("No email provided")
                    }
                    if list[j].pdf != nil {
                        documentsURL[i].append(list[j].pdf!)
                    }else{
                        documentsURL[i].append(nil)
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headNames[section]
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentsTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "myCell")
        
        //this displays the title and authors on the table
        cell.textLabel?.text = documentsTitle[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = documentsAuthor[indexPath.section][indexPath.row]
        //this checks if the toggle is turned on and if so turns on the checkmark
        //well its supposed to but it doesnt lol
        if isChecked == true{
            
            cell.accessoryType = .checkmark
        }else{
            
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this gets where the cell has been clicked to get the information
        cellRow = indexPath.row
        cellSection = indexPath.section
        performSegue(withIdentifier: "main", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //this sends all the information from the cell to the second view controller
        let vc = segue.destination as! SecondViewController
        vc.authorsOf = documentsAuthor[cellSection][cellRow]
        vc.docOf = documentsContent[cellSection][cellRow]
        vc.emailOf = documentsEmail[cellSection][cellRow]
        vc.titleOf = documentsTitle[cellSection][cellRow]
        vc.pdfLink = documentsURL[cellSection][cellRow]
        
    }
    
    /*let persistentManager : PersistenceManager
    
    init(persistentManager : PersistenceManager){
        
        self.persistentManager = persistentManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
    }


}


