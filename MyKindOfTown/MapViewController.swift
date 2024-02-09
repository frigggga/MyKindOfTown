//
//  MapViewController.swift
//  MyKindOfTown
//
//  Created by Zhang on 2024/2/5.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var hud: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
 
    
    override func viewWillAppear(_ animated: Bool) {
        setUpHUD()
        setUpMap()
        
    }
    
    func setUpHUD() {
        toggleHUD(true)
        titleLabel.text = "Navy Pier"
        descriptionLabel.text = "Navy Pier Terminal is a small passenger port and a very famous tourist attraction located in the central part of Chicago, the largest city of Illinois. It is a very popular entertainment facility visited by hundreds of people, both local residents and tourists."
        
        starButton.setImage(UIImage(systemName:"star")?.withTintColor(.yellow, renderingMode: .alwaysOriginal) , for: .normal)
        starButton.setImage(UIImage(systemName:"star.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal) , for: .selected)
        
    }
    
    func setUpMap() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(Place.self))
        
        DataManager.sharedInstance.loadAnnotationFromPlist()
        
        let region = DataManager.sharedInstance.getRegion()
        let coordinate = CLLocationCoordinate2D(latitude: region[0], longitude: region[1])
        let span = MKCoordinateSpan.init(latitudeDelta: region[2], longitudeDelta: region[3])
        mapView.region = MKCoordinateRegion.init(center: coordinate, span: span)
        
        let dicts = DataManager.sharedInstance.getPlaces()
        mapView.addAnnotations(Place.place(fromDictionaries: dicts))

    }
    
    func toggleHUD(_ value: Bool) {
        hud.isHidden = !value
        titleLabel.isHidden = !value
        descriptionLabel.isHidden = !value
    }
    
    @IBAction func addFavButton(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
            sender.tintColor = .clear
            sender.backgroundColor = .clear
            DataManager.sharedInstance.deleteFavorite(titleLabel.text!)
        }else{
            sender.isSelected = true
            DataManager.sharedInstance.saveFavorites(titleLabel.text!)
        }
    }

    @IBAction func favPlaceButton(_ sender: UIButton) {
        let favoritesViewController = self.storyboard?.instantiateViewController(identifier: "FavoritesViewController") as! PlacesViewController
        favoritesViewController.delegate = self
        
        let viewControllerToPresent = favoritesViewController
            if let sheet = viewControllerToPresent.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            }
            present(viewControllerToPresent, animated: true, completion: nil)
    }
    
}

extension MapViewController: PlacesFavoritesDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedAnnotation = mapView.selectedAnnotations.first(where: { $0 !== view.annotation }) {
            mapView.deselectAnnotation(selectedAnnotation, animated: false)
        }
        toggleHUD(true)
        
        let place = view.annotation as! Place
        titleLabel.text = place.name
        descriptionLabel.text = place.longDescription
        starButton.isSelected = DataManager.sharedInstance.isFavorite(place.name!)
        
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform.identity
        }
        toggleHUD(false)
    }
    
    
    func favoritePlace(name: String) {
        let dicts = DataManager.sharedInstance.getPlaces()
        let places = Place.place(fromDictionaries: dicts)

        if let foundPlace = places.first(where: { $0.name == name }) {
            let miles: Double = 20 * 160
            let zoomLocation = foundPlace.coordinate
            let viewRegion = MKCoordinateRegion(center: zoomLocation, latitudinalMeters: miles, longitudinalMeters: miles)
            mapView.setRegion(viewRegion, animated: true)
            
            let rect = self.viewForCoordinateRegion(region: viewRegion, inMapView: mapView)
            let overlayView = UIView(frame: rect)
            overlayView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            overlayView.layer.cornerRadius = 10
            overlayView.alpha = 0
            
            self.mapView.addSubview(overlayView)
            UIView.animate(withDuration: 2.0, animations: {
                overlayView.alpha = 1.0 // Fade in
            })
            
            UIView.animate(withDuration: 2.0, animations: {
                overlayView.alpha = 0.0 // Fade out
            })
            
            toggleHUD(true)
            titleLabel.text = foundPlace.name
            descriptionLabel.text = foundPlace.longDescription
        }
    }
    
    func viewForCoordinateRegion(region: MKCoordinateRegion, inMapView mapView: MKMapView) -> CGRect {
            let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
            let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

            let topLeftPoint = mapView.convert(topLeft, toPointTo: mapView)
            let bottomRightPoint = mapView.convert(bottomRight, toPointTo: mapView)

            return CGRect(x: topLeftPoint.x, y: topLeftPoint.y, width: bottomRightPoint.x - topLeftPoint.x, height: bottomRightPoint.y - topLeftPoint.y)
        }
}
