//
//  DataManager.swift
//  MyKindOfTown
//
//  Created by Zhang on 2024/2/5.
//

import Foundation
import MapKit

public class DataManager {
  
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()

    //This prevents others from using the default '()' initializer
    fileprivate init() {}


    let defaults = UserDefaults.standard
    var favList = [String]()
                             
    // Your code (these are just example functions, implement what you need)
    func loadAnnotationFromPlist() {
        defaults.set(favList, forKey: "mapFavorites")
        if let plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!) {
            if let region = plist["region"] as? [NSNumber] {
                var points = [Double]()
                for i in 0..<region.count {
                    points.append(region[i].doubleValue)
                }
                defaults.set(points, forKey: "mapRegion")
            }
            
            if let places = plist["places"] as? [[String : Any]] {
                defaults.set(places, forKey: "mapPlaces")
            }
            
        }
    }
    
    func getRegion() -> [Double] {
        return defaults.array(forKey:"mapRegion") as! [Double]
    }
    
    func getPlaces() -> [[String : Any]] {
        return defaults.object(forKey: "mapPlaces") as! [[String : Any]] 
    }
    
    func saveFavorites(_ title: String){
        var favList = self.listFavorites()
        favList.append(title)
        defaults.set(favList, forKey: "mapFavorites")
        
        
    }
    
    func deleteFavorite(_ title: String) {
        var favList = self.listFavorites()
        if let index = favList.firstIndex(of: title){
            favList.remove(at: index)
            defaults.set(favList, forKey: "mapFavorites")
        }
    }
    
    func listFavorites() -> [String] {
        return defaults.array(forKey: "mapFavorites") as! [String]
    }
    
    func isFavorite(_ name: String) -> Bool {
        return self.listFavorites().contains(name)
    }
    

}
