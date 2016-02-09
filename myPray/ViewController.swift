//
//  ViewController.swift
//  myPray
//
//  Created by Mohammed Owynat on 3/02/2016.
//  Copyright © 2016 Mohammed Owynat. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var fajrTime: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var dhuhurTime: UILabel!
    @IBOutlet weak var asrTime: UILabel!
    @IBOutlet weak var maghribTime: UILabel!
    @IBOutlet weak var ishaTime: UILabel!
    @IBOutlet weak var refreshedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentPrayerLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var fetchedResultsController = NSFetchedResultsController!
    
    var coreDataResults: [String]!
    
    var today: Today!
    var testLocation = CLLocation(latitude: -27.470125, longitude: 153.021072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dateOnly = NSDateFormatter()
        dateOnly.dateStyle = .MediumStyle
        dateLabel.text = dateOnly.stringFromDate(NSDate())
        
        today = Today(now: NSDate(), location: testLocation)
        
        today.getTodaysData { () -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.displayData()

                print(self.today.fajr)
                print(self.today.sunrise)
                print(self.today.dhuhur)
                print(self.today.asr)
                print(self.today.maghrib)
                print(self.today.isha)
                
                print(self.today.localityName)
                
                self.today.currentPrayer(NSDate())
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayData() {
        
        dateLabel.text = today.dateOnlyFormatter(today.now)
        
        refreshedLabel.hidden = false
        refreshButton.hidden = false
        
        refreshedLabel.text = "Last refreshed at: \(today.timeOnlyFormatter(today.now)) on \(today.dateOnlyFormatter(today.now))"
        
        fajrTime.text = today.fajr
        sunriseTime.text = today.sunrise
        dhuhurTime.text = today.dhuhur
        asrTime.text = today.asr
        maghribTime.text = today.maghrib
        ishaTime.text = today.isha
        locationLabel.text = today.localityName
        currentPrayerLabel.text = today.currentPrayer(today.now)
        
    }
    
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "StoredPrayers")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.coreDataResults = results as! [String]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        //displayData()
        today = Today(now: NSDate(), location: testLocation)
        today.getTodaysData { () -> () in
            self.displayData()
        }
    }

}

