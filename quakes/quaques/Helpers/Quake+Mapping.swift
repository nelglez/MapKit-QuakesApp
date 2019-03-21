//
//  Quake+Mapping.swift
//  quaques
//
//  Created by Nelson Gonzalez on 3/21/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import MapKit

//Allows the class to be turned into pins and placed on the map view.
extension Quake: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return geometry.location
    }
    
    //title and subtitle are optional. If added it will be shown under the pin
    var title: String? {
       return properties.place
    }
    
}
