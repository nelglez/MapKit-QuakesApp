//
//  Quake.swift
//  quaques
//
//  Created by Nelson Gonzalez on 3/21/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreLocation

class Quake: NSObject, Decodable {
    
    let properties: Properties
     let geometry: Geometry
    
    //What we want are:
    //place
    //magnitude
    //time
    struct Properties: Decodable {
        let mag: Double
        let place: String
        let time: Date
        
    }

    //lat
    //long
    
    
    struct Geometry: Decodable {
        
        enum GeometryCodingKeys: String, CodingKey {
            case coordinates
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: GeometryCodingKeys.self)
            
            var coordinatesContainer = try container.nestedUnkeyedContainer(forKey: .coordinates)
            
            let longitude = try coordinatesContainer.decode(CLLocationDegrees.self)//same thing as below
            let latitude = try coordinatesContainer.decode(Double.self)
            
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        }
         let location: CLLocationCoordinate2D
    }
    
    
    

    
}

//top level JSon
struct QuakeResults: Decodable {
    let features: [Quake]
}
