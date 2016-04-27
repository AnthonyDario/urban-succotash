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
    //make it a  map of phasset to location
    var locations = [CLLocation]()
    var locationNames = [String]()
    
    override func viewDidLoad() {
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

}
