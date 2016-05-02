//
//  ShowPictureViewController.swift
//  Picture Places
//
//  Created by Sophia Knowles on 4/14/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import Photos

class ShowPictureViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var useCurrentLabel: UILabel!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageTextField: UITextField!
    
    var image: UIImage = UIImage()
    var asset = PHAsset()
    var locationValue: CLLocationCoordinate2D = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDisplay.image = image
        let tbvc = tabBarController as! PictureTabController
        let locationName = tbvc.assetLocationNameMap[asset]
        
        if let name = locationName {
            if name == nil{
                imageTextField.text = "No Location Given"
            }
            else{
                imageTextField.text = name
                currentLocationSwitch.hidden = true
                useCurrentLabel.hidden = true
            }
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationValue = manager.location!.coordinate
    }
    

    @IBAction func saveChanges(sender: AnyObject) {
        let tbvc = tabBarController as! PictureTabController
        if currentLocationSwitch.on && !currentLocationSwitch.hidden {
            let actualLocation: CLLocation =  CLLocation(latitude: locationValue.latitude, longitude: locationValue.longitude)
            //let actualLocation = CLLocation(latitude: 40, longitude: 74)
            tbvc.assetLocationMap.updateValue(actualLocation, forKey: asset)
            tbvc.updateLocationName(asset, location: actualLocation, writtenName: nil)
        }
        else if currentLocationSwitch.hidden || !currentLocationSwitch.on{
            print("here")
            tbvc.updateLocationName(asset, location: nil, writtenName: imageTextField.text)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
