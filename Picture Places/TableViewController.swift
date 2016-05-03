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
    
    var assetList = [PHAsset]()
    var assetLocationMap = [PHAsset: CLLocation?]()
    var assetLocationNameMap = [PHAsset: String?]()
    var locationNames = [String]()
    var indexNameMap = [Int: PHAsset]()
    var noLocationAssetsMap = [PHAsset: CLLocation?]()
    var noLocationAssetsNamesMap = [PHAsset: String?]()
    var noLocationAssets = [PHAsset]()
    var selectedRow = -1
    @IBOutlet weak var viewImagesButton: UIButton!
    
    @IBAction func viewNoLocationImages(sender: AnyObject) {
        performSegueWithIdentifier("ToNoLocationImages", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let tbvc = tabBarController as! PictureTabController
        assetList = tbvc.assetList
        assetLocationMap = tbvc.assetLocationMap
        assetLocationNameMap = tbvc.assetLocationNameMap
        
        var index = 0;
        locationNames = [String]()
        noLocationAssets = [PHAsset]()
        for (asset, locationName) in assetLocationNameMap {
            if let actualLocationName = locationName{
                locationNames.append(actualLocationName)
                indexNameMap.updateValue(asset, forKey: index)
                index = index + 1;
            }
            else{
                //locationNames.append("No Location Given")
                noLocationAssetsMap.updateValue(assetLocationMap[asset]!, forKey: asset)
                noLocationAssetsNamesMap.updateValue(assetLocationNameMap[asset]!, forKey: asset)
                noLocationAssets.append(asset)
            }
            //indexNameMap.updateValue(asset, forKey: index)
            //index = index + 1;
        }
        
        if noLocationAssets.count == 0 {
            viewImagesButton.hidden = true
        }
        tableView.reloadData()
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
        //print(locationNames)
        cell.textLabel?.text = locationNames[indexPath.row]
       
        //cell.textLabel?.text = String(locations[indexPath.row])
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        performSegueWithIdentifier("ToImageView", sender: self)
        /*dispatch_async(dispatch_get_main_queue(),{
         self.performSegueWithIdentifier("ToImageView", sender:self)
         })*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //print(findKeyForValue(locationNames[selectedRow], dictionary: assetLocationNameMap))
        if segue.identifier == "ToImageView" {
            if let destination = segue.destinationViewController as? ShowPictureViewController {
                let manager = PHImageManager.defaultManager()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                destination.asset = indexNameMap[selectedRow]!
                option.synchronous = true
                option.deliveryMode = .HighQualityFormat
                manager.requestImageForAsset(indexNameMap[selectedRow]!, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    destination.image = thumbnail
                })
                //print(assetList[selectedRow])
                //destination.imageDisplay = self.locationNames
            }
        }
        else if segue.identifier == "ToNoLocationImages" {
            if let destination = segue.destinationViewController as? CollectionViewController {
                print("here")
                destination.noLocationAssetsMap = noLocationAssetsMap
                destination.noLocationAssetsNamesMap = noLocationAssetsNamesMap
                destination.noLocationAssets = noLocationAssets
            }
        }
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
