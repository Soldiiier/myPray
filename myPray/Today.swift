//
//  Today.swift
//  myPray
//
//  Created by Mohammed Owynat on 5/02/2016.
//  Copyright © 2016 Mohammed Owynat. All rights reserved.
//

import Foundation
import CoreLocation

class Today {
    private var _now: NSDate!
    private var _unixDate: Int!
    private var _currentLocation: CLLocation!
    private var _latitude: Double!
    private var _longitude: Double!
    private var _calcMethod: Int!
    private var _localityName: String!
    private var _timeZone: String!
    private var _todayURL: String!
    private var _fajr: String!
    private var _sunrise: String!
    private var _dhuhur: String!
    private var _asr: String!
    private var _maghrib: String!
    private var _isha: String!
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    var now: NSDate {
        if _now == nil {
            _now = NSDate()
        }
        return _now
    }
    
    var unixDate: Int {
        if _unixDate == nil {
            _unixDate = Int(_now.timeIntervalSince1970)
        }
        return _unixDate
    }
    
    var currentLocation: CLLocation {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
            _currentLocation = locationManager.location
        } else {
            _currentLocation = CLLocation()
        }
        return _currentLocation
    }
    
    var latitude: Double {
        if _latitude == nil {
            _latitude = _currentLocation.coordinate.latitude
        }
        return _latitude
    }
    
    var longitude: Double {
        if _longitude == nil {
            _longitude = _currentLocation.coordinate.longitude
        }
        return _longitude
    }
    
    var calcMethod: Int {
        if _calcMethod == nil || _calcMethod == 0 {
            _calcMethod = 3
        }
        return _calcMethod
    }
    
    var timeZone: String {
        if _timeZone == nil {
            let dateFormatter = NSDateFormatter()
            let fullTimeZoneString = "\(dateFormatter.timeZone)"
            let delimiter = NSCharacterSet(charactersInString: " ")
            let dividedString = NSCharacterSet.newlineCharacterSet()
            fullTimeZoneString.stringByTrimmingCharactersInSet(dividedString).enumerateLines { line, stop in self._timeZone }
            _timeZone = fullTimeZoneString.componentsSeparatedByCharactersInSet(delimiter)[0]
        }
        return _timeZone
    }
    
    var localityName: String {
        if _localityName == nil {
            print("got here")
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error: " + (error?.localizedDescription)!)
                    print("got here 2")
                    self._localityName = "Failed"
                }
                if placemarks?.count > 0 {
                    let pm = placemarks![0] as CLPlacemark

                    self._localityName = pm.locality
                    //print(placemarks)
                    print("got here 3")
                } else {
                    self._localityName = "none"
                    print("got here 4")
                }
            })
        }
        
        _localityName = "test locality"
        return _localityName
    }
    var todayURL: String {
        _todayURL = "\(URL_BASE)/\(unixDate)?latitude=\(latitude)&longitude=\(longitude)&timezonestring=\(timeZone)&method=\(calcMethod)"
        return _todayURL
    }
    
    var fajr: String {
        if _fajr == nil {
            _fajr = ""
        }
        return _fajr
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var dhuhur: String {
        if _dhuhur == nil {
            _dhuhur = ""
        }
        return _dhuhur
    }
    
    var asr: String {
        if _asr == nil {
            _asr = ""
        }
        return _asr
    }
    
    var maghrib: String {
        if _maghrib == nil {
            _maghrib = ""
        }
        return _maghrib
    }
    
    var isha: String {
        if _isha == nil {
            _isha = ""
        }
        return _isha
    }
    
    init(now: NSDate, location: CLLocation) {
        self._now = now
        self._currentLocation = location
    }
    
    func getTodaysData(completed: DownloadComplete) {
        let session = NSURLSession.sharedSession()
        let nsURL = NSURL(string: self.todayURL)!
        
        session.dataTaskWithURL(nsURL) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseData = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    if let prayersJSON = json as? Dictionary<String, AnyObject> {
                        if let todaysDataDict = prayersJSON["data"] as? Dictionary<String, AnyObject> {
                            if let timingsDict = todaysDataDict["timings"] as? Dictionary<String, AnyObject> {
                                if let fajrTimeString = timingsDict["Fajr"] as? String {
                                    self._fajr = fajrTimeString
                                }
                                if let sunriseTimeString = timingsDict["Sunrise"] as? String {
                                    self._sunrise = sunriseTimeString
                                }
                                if let dhuhurTimeString = timingsDict["Dhuhr"] as? String {
                                    self._dhuhur = dhuhurTimeString
                                }
                                if let asrTimingString = timingsDict["Asr"] as? String {
                                    self._asr = asrTimingString
                                }
                                if let maghribTimingString = timingsDict["Maghrib"] as? String {
                                    self._maghrib = maghribTimingString
                                }
                                if let ishaTimingString = timingsDict["Isha"] as? String {
                                    self._isha = ishaTimingString
                                }
                            }
                        }
                    }
                    completed()
                } catch {
                    print("Could not serialise")
                }
            }
        }.resume()
    }
    
    func currentPrayer(currentTime: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy HH:mm"
        
        let fajrTimeFullString = dateOnlyFormatter(NSDate()) + " " + fajr
        let sunriseTimeFullString = dateOnlyFormatter(NSDate()) + " " + sunrise
        let dhuhurTimeFullString = dateOnlyFormatter(NSDate()) + " " + dhuhur
        let asrTimeFullString = dateOnlyFormatter(NSDate()) + " " + asr
        let maghribTimeFullString = dateOnlyFormatter(NSDate()) + " " + maghrib
        let ishaTimeFullString = dateOnlyFormatter(NSDate()) + " " + isha

        print(fajrTimeFullString)
        print(sunriseTimeFullString)
        print(ishaTimeFullString)
        
        let fajrTimeUnix = unixFormatter(fajrTimeFullString)
        let sunriseTimeUnix = unixFormatter(sunriseTimeFullString)
        let dhuhurTimeUnix = unixFormatter(dhuhurTimeFullString)
        let asrTimeUnix = unixFormatter(asrTimeFullString)
        let maghribTimeUnix = unixFormatter(maghribTimeFullString)
        let ishaTimeUnix = unixFormatter(ishaTimeFullString)
        
        if unixDate < fajrTimeUnix {
            return "Isha"
        } else if fajrTimeUnix < unixDate && unixDate < sunriseTimeUnix {
            return "Fajr"
        } else if sunriseTimeUnix < unixDate && unixDate < dhuhurTimeUnix {
            return "No Prayers"
        } else if dhuhurTimeUnix < unixDate && unixDate < asrTimeUnix {
            return "Dhuhur"
        } else if asrTimeUnix < unixDate && unixDate < maghribTimeUnix {
            return "Asr"
        } else if maghribTimeUnix < unixDate && unixDate < ishaTimeUnix {
            return "Maghrib"
        } else if unixDate > ishaTimeUnix {
            return "Isha"
        } else {
            return "Problem"
        }
        
    }
    
    func dateOnlyFormatter(nsDate: NSDate) -> String {
        let dateOnly = NSDateFormatter()
        dateOnly.dateStyle = .FullStyle
        return dateOnly.stringFromDate(nsDate)

    }
    
    func timeOnlyFormatter(nsDate: NSDate) -> String {
        let timeOnly = NSDateFormatter()
        timeOnly.timeStyle = .MediumStyle
        return timeOnly.stringFromDate(nsDate)
    }
    
    func unixFormatter(stringDate: String) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy HH:mm"
        let date = dateFormatter.dateFromString(stringDate) as NSDate!
        return Int(date.timeIntervalSince1970)
    }
}