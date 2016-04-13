//
//  TableViewController.swift
//  Picture Places
//
//  Created by Sophia Knowles on 4/13/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import Photos

class TableViewController: UITableViewController {
    
    var locations = [CLLocation]()
    var locationNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        print(locationNames)
        let photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        photosAsset.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
            let asset = object as! PHAsset
            print(asset)
            if let location = asset.location{
                self.locations.append(location);
            }
        })
        
        for i in 0...locations.count - 1{
            updateLocationName(locations[i], index: i)
        }

        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        /*let photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        photosAsset.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
            let asset = object as! PHAsset
            print(asset)
            if let location = asset.location{
                self.locations.append(location);
            }
        })
        
        for i in 0...locations.count - 1{
            updateLocationName(locations[i], index: i)
        }*/
        print("here2")
        print(locationNames)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        //let pictureLocation = locations[indexPath.row]
        print(locationNames)
        cell.textLabel?.text = locationNames[indexPath.row]
        //cell.textLabel?.text = String(locations[indexPath.row])
        // Configure the cell...

        return cell
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
                print(pm.name)
                //print(pm.region)
                //print(pm.locality)
            }
            else {
                self.locationNames.append("Problem with the data received from geocoder")
            }
            //figure out how to return and use the location name - sort of jerry rigging it right now and it isn't working properly...
        })
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
