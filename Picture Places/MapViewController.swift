//
//  ViewController.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/10/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        // ask for location permission
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        // ask for notification permission
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let not = UILocalNotification()
        not.alertAction = "what up"
        not.alertBody = "col"
        not.hasAction = true
        let current = NSDate().dateByAddingTimeInterval(10)
        not.fireDate = current
        //let reg = CLCircularRegion(center: CLLocationCoordinate2DMake(51.5, 0.12), radius: 1000, identifier: "london")
        //not.region = reg
        UIApplication.sharedApplication().scheduleLocalNotification(not)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //map.setCenterCoordinate(locations[0].coordinate, animated: true)
        var viewRegion = MKCoordinateRegionMakeWithDistance(locations[0].coordinate, 5000, 5000)
        viewRegion = map.regionThatFits(viewRegion)
        map.setRegion(viewRegion, animated: true)
        
        manager.stopUpdatingLocation()
    }

}

