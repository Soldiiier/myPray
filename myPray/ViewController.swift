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
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var coreDataResults: [StoredPrayers]!
    
    var today: Today!
    var testLocation = CLLocation(latitude: -27.470125, longitude: 153.021072)
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        backgroundImage.image = UIImage(named: "day4")
        
        let storedPrayers = NSEntityDescription.insertNewObjectForEntityForName("StoredPrayers", inManagedObjectContext: self.managedObjectContext) as! StoredPrayers
        
        print(storedPrayers.ishaTime)
        
        //fetchAndSetResults()
        
        today = Today(now: NSDate(), location: testLocation)
        dateLabel.text = today.dateOnlyFormatter(NSDate())
        
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

        UIView.animateWithDuration(1.0 , animations: { () -> Void in
            
            self.dateLabel.text = self.today.dateOnlyFormatter(self.today.now)
            
//            self.refreshedLabel.hidden = false
//            self.refreshButton.hidden = false

            self.prepareImageFileName()
            
            self.refreshedLabel.text = "Last refreshed at: \(self.today.timeOnlyFormatter(self.today.now)) on \(self.today.dateOnlyFormatter(self.today.now))"

            self.fajrTime.text = self.today.fajr
            self.sunriseTime.text = self.today.sunrise
            self.dhuhurTime.text = self.today.dhuhur
            self.asrTime.text = self.today.asr
            self.maghribTime.text = self.today.maghrib
            self.ishaTime.text = self.today.isha
            self.locationLabel.text = self.today.localityName
            self.currentPrayerLabel.text = self.today.currentPrayer(self.today.now)
            }, completion: nil)
        
//        dateLabel.text = today.dateOnlyFormatter(today.now)
//        
//        refreshedLabel.hidden = false
//        refreshButton.hidden = false
//
//        refreshedLabel.text = "Last refreshed at: \(today.timeOnlyFormatter(today.now)) on \(today.dateOnlyFormatter(today.now))"
//        
//        fajrTime.text = today.fajr
//        sunriseTime.text = today.sunrise
//        dhuhurTime.text = today.dhuhur
//        asrTime.text = today.asr
//        maghribTime.text = today.maghrib
//        ishaTime.text = today.isha
//        locationLabel.text = today.localityName
//        currentPrayerLabel.text = today.currentPrayer(today.now)
        
    }
    
    func prepareImageFileName() {
        if today.currentPrayer(NSDate()) == "Isha" {
            let num = arc4random_uniform(9)
            backgroundImage.image = UIImage(named: "night\(num)")
        } else if today.currentPrayer(NSDate()) == "Fajr" {
            let num = arc4random_uniform(4)
            backgroundImage.image = UIImage(named: "sunrise\(num)")
        } else if today.currentPrayer(NSDate()) == "No Prayers" {
            let num = arc4random_uniform(4)
            backgroundImage.image = UIImage(named: "morning\(num)")
        } else if today.currentPrayer(NSDate()) == "Dhuhur" {
            let num = arc4random_uniform(6)
            backgroundImage.image = UIImage(named: "day\(num)")
        } else if today.currentPrayer(NSDate()) == "Asr" {
            let num = arc4random_uniform(1)
            backgroundImage.image = UIImage(named: "afternoon\(num)")
        } else if today.currentPrayer(NSDate()) == "Maghrib" {
            let num = arc4random_uniform(4)
            backgroundImage.image = UIImage(named: "sunset\(num)")
        }
        
    }
    
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "StoredPrayers")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.coreDataResults = results as! [StoredPrayers]
            print(self.coreDataResults[0])
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        today = Today(now: NSDate(), location: testLocation)
        today.getTodaysData { () -> () in
            self.displayData()
        }
    }

}

