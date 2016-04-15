//
//  ViewController.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/10/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicked: UIImageView!
    var locations = [CLLocation]()
    var locationNames = [String]()
    var assetList = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //check to see if the authorization status has been granted?
        let photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        photosAsset.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
            let asset = object as! PHAsset
            self.assetList.append(asset)
            if let location = asset.location{
                self.locations.append(location);
            }
        })
        
        for i in 0...locations.count - 1{
            updateLocationName(locations[i], index: i)
        }
    }
    
    func updateLocationName(location: CLLocation, index: Int) -> Void {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                self.locationNames.append("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.locationNames.append(pm.name!)
                //print(pm.name)
                let hold = pm.addressDictionary!
                let test = hold.description
               /* let subadministrativeArea = hold[0]
                let state = hold[1]?.fullState
                let countryCode = hold[2]?.country
                let zip = hold[3]
                let country = hold[4]
                let name = hold[5]
                let formattedAddressLines = hold[6]
                let city = hold[7]8*/
                //print(hold.state)
                //print(pm.region)
                //print(pm.locality)
            }
            else {
                self.locationNames.append("Problem with the data received from geocoder")
            }
            //figure out how to return and use the location name - sort of jerry rigging it right now and it isn't working properly...
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ListRegionsSegue" {
            if let destination = segue.destinationViewController as? TableViewController {
                destination.locationNames = self.locationNames
                destination.assetList = self.assetList
            }
        }
    }
    
    /*override func viewDidAppear(animated: Bool) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .Authorized {
            //  Permission Authorized
            print("a")
            let images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
            var locations = [CLLocation]();
            images.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                let asset = object as! PHAsset
                if let location = asset.location{
                    locations.append(location);
                }
            })
            print(locations)
            
            //select a photo and change its location if not set
            //add a photo using the camera and set its location
            
            //self.openPhotoLibraryButton();
            //call function to use photos
        } else if status == .Restricted {
            //  Permission Restricted
            print("b")
        } else if status == .NotDetermined {
            //  Permission Not Determined
            print("c")
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                //call function to use photos
                switch status {
                case .Authorized:
                    // as above
                    //call function to access photos
                    //self.openPhotoLibraryButton();
                    PHPhotoLibrary.sharedPhotoLibrary()
                    break;
                case .Denied, .Restricted:
                    // as above
                    break;
                case .NotDetermined:
                    // won't happen but still
                    break;
                }
            })
        } else if status == .Denied {
            //  Permission Denied
            print("d")
        }
    }*/
    
    /*func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked.image = image
        //let library =
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imageFromAsset(nsurl: NSURL) {
        let asset = PHAsset.fetchAssetsWithALAssetURLs([nsurl], options: nil).firstObject as! PHAsset
        print("location: " + String(asset.location))
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

