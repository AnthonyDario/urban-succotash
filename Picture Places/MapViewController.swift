//
//  ViewController.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/10/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import MapKit
import Photos

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    var assetList = [PHAsset]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        let tbvc = tabBarController as! PictureTabController
        assetList = tbvc.assetList
        
        // ask for location permission
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        // adding pins
        for picture in assetList {
            if let location = picture.location {
                if let date = picture.creationDate {
                    dropPin(location.coordinate, title: date.description)
                }
            }
        }
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
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation.isKindOfClass(PictureAnnotation) {
            let picAnnotation = annotation as? PictureAnnotation
            
            var annotationView = map.dequeueReusableAnnotationViewWithIdentifier("Picture Annotation") as MKAnnotationView!
            
            if annotationView == nil {
                annotationView = PictureAnnotationView(annotation: picAnnotation)
                annotationView.canShowCallout = true
            } else {
                annotationView.annotation = annotation;
            }
            
            configureAnnotationView(annotationView!)
            
            return annotationView
            
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let _ = view as? PictureAnnotationView {
            print("Got the view bitches!")
        }
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
    
    // MARK: Helper functions
    
    private func configureAnnotationView(view: MKAnnotationView) {
        let image = UIImage(named: "Hoot")
        let imageView = UIImageView(image: image)
        view.detailCalloutAccessoryView = imageView
    }
    
    private func dropPin(coordinate: CLLocationCoordinate2D, title: String) {
        
        //let picture = UIImage(named: "Hoot")
        let pin = PictureAnnotation(coordinate: coordinate, title: title)
        //let newPin = PictureAnnotationView(annotation: pin)
        map.addAnnotation(pin)
    }

}

