//
//  PictureAnnotation.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/27/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import MapKit

// the annotation for the picture
class PictureAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var picture: UIImage!
    
    init (coordinate: CLLocationCoordinate2D, title: String, image: UIImage) {
        self.coordinate = coordinate
        self.title = title
        picture = image
    }
    
}

// the view for the annotation
class PictureAnnotationView: MKPinAnnotationView {

    class var reuseIdentifier: String {
        return "Picture Annotation"
    }
    
    convenience init(annotation: MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: PictureAnnotationView.reuseIdentifier)
        
    }
    
}

// The callout of the annotation
class PictureCallout: UIView {
    
}
