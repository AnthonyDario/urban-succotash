//
//  CameraViewController.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/27/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var locationValue: CLLocationCoordinate2D = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            //load the camera interface
            
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
            
        }else{
            //no camera available
            
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationValue = manager.location!.coordinate
    }
    
    // MARK: UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func takePictureButtonPressed(sender: AnyObject) {
        // TODO: actually take the picture...
        
        //actually the save button?
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(self.imageView.image!)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset) {
                albumChangeRequest.addAssets([assetPlaceholder!])
            }
        }, completionHandler: { success, error in
                print("added image to album")
                print(error)
                let newAssets = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
                let newPhoto = newAssets.lastObject as! PHAsset
                let tbvc = self.tabBarController as! PictureTabController
                let actualLocation: CLLocation =  CLLocation(latitude: self.locationValue.latitude, longitude: self.locationValue.longitude)
                //let actualLocation = CLLocation(latitude: 40, longitude: 74)
                //adding this image to our lists
                tbvc.assetLocationMap.updateValue(actualLocation, forKey: newPhoto)
                tbvc.updateLocationName(newPhoto, location: actualLocation)
        })
    }
}
