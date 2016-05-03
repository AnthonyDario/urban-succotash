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
    var assetLocationMap = [PHAsset: CLLocation?]()
    var assetLocationNameMap = [PHAsset: String?]()
    var currentAsset: PHAsset?
    var homeAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mapView: viewDidLoad")
        
        manager.delegate = self
        map.delegate = self
    
        // ask for location permission
        print("requesting location permission")
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPress(_:)))
        longPress.minimumPressDuration = 1.0
        self.map.addGestureRecognizer(longPress)

    }
    
    override func viewWillAppear(animated: Bool) {
        
        manager.startUpdatingLocation()
        let tbvc = tabBarController as! PictureTabController
        assetList = tbvc.assetList
        assetLocationMap = tbvc.assetLocationMap
        assetLocationNameMap = tbvc.assetLocationNameMap
        
        let picManager = PHImageManager()
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        
        // adding pins
        print("iterating through \(assetList.count) pictures")
        for picture in assetList {
            
            picManager.requestImageForAsset(picture, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: options, resultHandler: {(result, info) -> Void in
                
                if let pic = result {
                    
                    if let location = self.assetLocationMap[picture]! {
                        
                        
                        if let name = self.assetLocationNameMap[picture] {
                            self.dropPin(location.coordinate, title: name!, image: pic, asset: picture)
                        }
                        else {
                            self.dropPin(location.coordinate, title: "No Name", image: pic, asset: picture)
                        }
                    }
                }
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        for subview in map.subviews {
            if subview.isKindOfClass(UIButton) {
                subview.removeFromSuperview()
            }
        }
        
        for annotation in map.selectedAnnotations {
            map.deselectAnnotation(annotation, animated: false)
        }
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
            } else {
                annotationView.annotation = annotation;
            }
            
            return annotationView
            
        } else {
            print("added different view")
            let view = PictureAnnotationView(annotation: annotation)
            view.pinColor = .Green
            return view
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let picView = view as? PictureAnnotationView {
            if let picAnnotation = picView.annotation as? PictureAnnotation {
                let frame = CGRectMake(picView.frame.origin.x - 18, picView.frame.origin.y - 60, 50,50)
                let image = picAnnotation.picture
                let button = UIButton(type: .Custom)
                
                button.addTarget(self, action: #selector(MapViewController.selectedButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                button.frame = frame
                button.setImage(image, forState: UIControlState.Normal)
                self.map.addSubview(button)
                currentAsset = picAnnotation.asset
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
       
        for subview in map.subviews {
            if subview.isKindOfClass(UIImageView) {
                subview.removeFromSuperview()
            }
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var viewRegion = MKCoordinateRegionMakeWithDistance(locations[0].coordinate, 5000, 5000)
        viewRegion = map.regionThatFits(viewRegion)
        map.setRegion(viewRegion, animated: true)
        
        manager.stopUpdatingLocation()
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPicture" {
            if let destination = segue.destinationViewController as? ShowPictureViewController {
                if let button = sender as? UIButton {
                    destination.image = (button.imageView?.image)!
                    destination.asset = currentAsset!
                }
            }
        }
    }
    
    // MARK: Helper functions
    
    private func dropPin(coordinate: CLLocationCoordinate2D, title: String, image: UIImage, asset: PHAsset) {
        
        
        let pin = PictureAnnotation(coordinate: coordinate, title: title, image: image, asset: asset)
        map.addAnnotation(pin)
    }
    
    @objc private func selectedButton (sender: UIButton) {
        performSegueWithIdentifier("ShowPicture", sender: sender)
    }
    
    @objc private func longPress(recognizer: UILongPressGestureRecognizer) {
        print("longPress")
        
        if let home = homeAnnotation {
            map.removeAnnotation(home)
        }
        homeAnnotation = MKPointAnnotation()
        let touchPoint = recognizer.locationInView(self.map)
        let coordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        homeAnnotation!.coordinate = coordinate
        map.addAnnotation(homeAnnotation!)
        
        let not = UILocalNotification()
        not.alertAction = "Take a Picture!"
        not.alertBody = "Now!!!!"
        not.hasAction = true
        let reg = CLCircularRegion(center: coordinate, radius: 1000, identifier: "home")
        not.region = reg
        UIApplication.sharedApplication().scheduleLocalNotification(not)
    }

}

