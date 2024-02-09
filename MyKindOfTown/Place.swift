//
//  Place.swift
//  MyKindOfTown
//
//  Created by Zhang on 2024/2/5.
//

import Foundation
import MapKit

class Place: MKPointAnnotation {
    var name: String?
    var longDescription: String?
    var type: Int?
    
    class func place(fromDictionaries dictionaries: [[String: Any]]) -> [Place] {
        let places = dictionaries.compactMap { item -> Place? in
                    guard let lat = item["lat"] as? CLLocationDegrees, // Cast to CLLocationDegrees
                          let long = item["long"] as? CLLocationDegrees, // Cast to CLLocationDegrees
                          let name = item["name"] as? String, // Cast to String
                          let description = item["description"] as? String, // Cast to String
                          let type = item["type"] as? Int else { // Cast to Int
                        print("Invalid data format")
                        return nil // Return nil if any casting fails
                    }
                    
                    let place = Place()
                    place.name = name
                    place.longDescription = description
                    place.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long) // Correctly create CLLocationCoordinate2D
                    place.type = type
                    return place
                }
                return places
    }
}
