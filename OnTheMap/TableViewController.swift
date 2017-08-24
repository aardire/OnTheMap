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
    
    
    // MARK: Outlets
    
    @IBOutlet var studentsTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ParseClient.sharedInstance.returnStudents(100) { (success) in
            
            performUIUpdatesOnMain {
                if success {
                    self.studentsTableView.reloadData()
                } else {
                    self.showAlert(message: ErrorMessages.studentError)
                }
            }
        }
    }


    @IBAction func refreshButton(_ sender: Any) {
        
        performUIUpdatesOnMain {
            self.viewDidLoad()
        }
    }

    @IBAction func logoutButton(_ sender: Any) {
        
        UdactiyClient.sharedInstance.udactiySessionDELETE() {(success) in
            
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(message: ErrorMessages.logoutError)
                }
            }
        }
            
    }
    
    
    
    
// MARK: TableViewController : UITableViewDelegate, UITableViewDataSource

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "StudentsTableViewCell"
        let student = StudentData.locationArray[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell?.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.locationArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let student = StudentData.locationArray[(indexPath as NSIndexPath).row]
        let toOpen = student.mediaURL
        var componets = URLComponents()
        componets.scheme = "HTTPS"
        componets.host = toOpen
        app.open(componets.url!)
    }
    
}
