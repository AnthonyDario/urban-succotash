//
//  PictureAnnotation.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/27/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import MapKit

// the annotation for the picture
class PictureAnnotation: MKAnnotationView {

    class var reuseIdentifier: String {
        return "Picture Annotation"
    }
    
    convenience init(annotation: MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: PictureAnnotation.reuseIdentifier)
        
    }
    
}

// The callout of the annotation
class PictureCallout: UIView {
    
}
