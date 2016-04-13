//
//  AddPhotoViewController.swift
//  Picture Places
//
//  Created by Sophia Knowles on 4/11/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit
import Photos

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var imageOutlet: UIImageView!
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var locations = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        photosAsset.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
            let asset = object as! PHAsset
            if let location = asset.location{
                self.locations.append(location);
            }
        })
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        //only do this when you want to see the new changes (PHPhotoLibrary - register change observer)
    }
    
    func photoLibraryDidChange(changeInstance: PHChange){
        let changeDetails = changeInstance.changeDetailsForFetchResult(photosAsset)
        print(changeDetails)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageOutlet.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func chooseFromLibraryButton(sender: AnyObject) {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }

    
    @IBAction func takePictureButton(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
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
    
    @IBAction func saveButton(sender: AnyObject) {
        //only want to add this when taking a picture from the camera... but just testing some stuff out
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(self.imageOutlet.image!)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset) {
                albumChangeRequest.addAssets([assetPlaceholder!])
            }
            }, completionHandler: { success, error in
                print("added image to album")
                print(error)
                let newAssets = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
                let newPhoto = newAssets.lastObject
                print(newPhoto)
                //just adding a test location at the moment
                self.locations.append(CLLocation(latitude: 44.4280, longitude: 110.5885))
                //print(self.locations);
        })
    
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
