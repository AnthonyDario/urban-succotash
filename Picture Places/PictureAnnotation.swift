//
//  PictureAnnotation.swift
//  Picture Places
//
//  Created by Anthony Dario on 4/27/16.
//  Copyright © 2016 Sophario. All rights reserved.
//

import MapKit

class PictureAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var annotationView: MKAnnotationView
    
    init (coordinate: CLLocationCoordinate2D, picture: UIImage) {
        annotationView = MKAnnotationView()
        annotationView.image = picture
        self.coordinate = coordinate
    }
    
}
