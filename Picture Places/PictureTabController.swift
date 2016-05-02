//
//  PictureTabController.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/27/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import Photos

class PictureTabController: UITabBarController {
    
    var assetList = [PHAsset]()
    var assetLocationMap = [PHAsset: CLLocation?]()
    var assetLocationNameMap = [PHAsset: String?]()
    
    override func viewDidLoad() {
        let photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        print("getting assets")
        photosAsset.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
            let asset = object as! PHAsset
            
            self.assetList.append(asset)
            if let location = asset.location{
                self.assetLocationMap.updateValue(location, forKey: asset)
            }
            else{
                self.assetLocationMap.updateValue(nil, forKey: asset)
            }
        })
        print("\tgot all assets")
        
        print("updating name map")
        for (asset, location) in assetLocationMap{
            updateLocationName(asset, location: location)
        }
        print("\tupdated name map")
        
        //selectedViewController = viewControllers![1]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue: \(segue.identifier)")
    }
    
    func updateLocationName(asset: PHAsset, location: CLLocation?) -> Void {
        if let actualLocation = location{
            CLGeocoder().reverseGeocodeLocation(actualLocation, completionHandler: {(placemarks, error) -> Void in
                
                if error != nil {
                    self.assetLocationNameMap.updateValue("Reverse geocoder failed with error" + error!.localizedDescription, forKey: asset)
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    self.assetLocationNameMap.updateValue(pm.name!, forKey: asset)
                    //print(pm.name)
                    //let hold = pm.addressDictionary!
                    //let test = hold.description
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
                     self.assetLocationNameMap.updateValue("Problem with the data received from geocoder", forKey: asset)
                }
            })
        }
        else{
            self.assetLocationNameMap.updateValue(nil, forKey: asset)
        }
    }

}
