//
//  PlaceMarkerView.swift
//  MyKindOfTown
//
//  Created by Zhang on 2024/2/5.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    
        private let boxInset = CGFloat(10)
        private let interItemSpacing = CGFloat(10)
        private let maxContentWidth = CGFloat(90)
        private let contentInsets = UIEdgeInsets(top: 10, left: 30, bottom: 20, right: 20)
    
    
        private lazy var label: UILabel = {
            let label = UILabel(frame: .zero)
            label.textColor = UIColor.white
            label.lineBreakMode = .byWordWrapping
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 2
            label.font = UIFont.preferredFont(forTextStyle: .caption1)
    
            return label
        }()
        
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemRed
            glyphImage = UIImage(systemName: "pin.fill")
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        /*
         If using the same annotation view and reuse identifier for multiple annotations, iOS will reuse this view by calling `prepareForReuse()`
         so the view can be put into a known default state, and `prepareForDisplay()` right before the annotation view is displayed. This method is
         the view's oppurtunity to update itself to display content for the new annotation.
         */
        if let annotation = annotation as? Place {
            label.text = annotation.name
            }
        }
}
