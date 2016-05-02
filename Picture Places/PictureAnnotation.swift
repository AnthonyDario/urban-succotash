//
//  PictureAnnotation.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/27/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import MapKit
import Photos

// the annotation for the picture
class PictureAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var picture: UIImage!
    var asset: PHAsset
    
    init (coordinate: CLLocationCoordinate2D, title: String, image: UIImage, asset: PHAsset) {
        self.coordinate = coordinate
        self.title = title
        picture = image
        self.asset = asset
    }
    
}

// the view for the annotation
class PictureAnnotationView: MKPinAnnotationView {
    
    class var reuseIdentifier: String {
        return "Picture Annotation"
    }
    
    convenience init(annotation: MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: PictureAnnotationView.reuseIdentifier)
         self.canShowCallout = false
    }
    
}

class PictureAnnotationCalloutView: MKAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
