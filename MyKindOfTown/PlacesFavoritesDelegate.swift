//
//  PlacesFavoritesDelegate.swift
//  MyKindOfTown
//
//  Created by Zhang on 2024/2/5.
//

import Foundation

protocol PlacesFavoritesDelegate: AnyObject {
    func favoritePlace(name: String) -> Void
}
