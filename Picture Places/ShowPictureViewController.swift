//
//  ShowPictureViewController.swift
//  Picture Places
//
//  Created by Sophia Knowles on 4/14/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import UIKit

class ShowPictureViewController: UIViewController {

    @IBOutlet weak var imageDisplay: UIImageView!
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDisplay.image = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
