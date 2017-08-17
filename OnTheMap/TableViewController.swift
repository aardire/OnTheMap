//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/17/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

// MARK: TableViewController

class TableViewController: UITableViewController {
    
    // MARK: Properties 
    
    var students:[StudentLocation] = [StudentLocation]()
    
    // MARK: Outlets
    
    @IBOutlet var studentsTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().createStudentsDictionary { (studentsDict,error) in
            
            if let studentsDict = studentsDict {
                self.students = studentsDict
                performUIUpdatesOnMain {
                    self.studentsTableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
        
    }
    


// MARK: TableViewController : UITableViewDelegate, UITableViewDataSource

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "StudentsTableViewCell"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell?.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let student = students[(indexPath as NSIndexPath).row]
        let toOpen = student.mediaURL
        app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
    }
    
}
