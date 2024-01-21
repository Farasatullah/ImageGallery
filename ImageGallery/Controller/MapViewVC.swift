//
//  MapViewVC.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 19/01/2024.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class MapViewVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var zoomInBtn: UIButton!
    @IBOutlet weak var zoomOutBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    let locationManager = CLLocationManager()
    let geocoder = GMSGeocoder()
    var placesClient = GMSPlacesClient.shared()
    let marker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        getLocation()
        configureSearchField()

    }
    
    @IBAction func zoomInBtnPressed(_ sender: Any) {
        
        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom + 1)
    }
    
    
    @IBAction func zoomOutBtnPressed(_ sender: Any) {
        let currentZoom = mapView.camera.zoom
                mapView.animate(toZoom: currentZoom - 1)
    }
    
}
extension MapViewVC{
    
    func configureSearchField(){
        
        searchField.delegate = self
        searchField.returnKeyType = .done
        
    }
    func getLocation(){
        
        if let location = locationManager.location?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
            mapView.camera = camera
            
            // Creates a marker at the current location
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            marker.title = "Current Location"
            marker.map = mapView
    
        }
    }
    func searchLocation(query: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment

        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil, callback: { (results, error) in
            
            guard error == nil, let results = results else {
                print("Autocomplete query failed with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let firstResult = results.first {
                self.handleAutocompleteResult(result: firstResult)
            }
        })
    }

    func handleAutocompleteResult(result: GMSAutocompletePrediction) {
        
        placesClient.lookUpPlaceID(result.placeID ?? "") { (place, error) in
            if let place = place {
//                let marker = GMSMarker()
                self.marker.position = place.coordinate
                self.marker.title = result.attributedFullText.string
                self.marker.map = self.mapView

                // Adjust camera to the searched location
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                      longitude: place.coordinate.longitude,
                                                      zoom: 15.0)
                self.mapView.animate(to: camera)
            } else if let error = error {
                print("Place lookup failed with error: \(error.localizedDescription)")
            }
        }
    }


}
//extension MapViewController: GMSMapViewDelegate {
//    // Implement any map view delegate methods you need
//}
extension MapViewVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Implement your search logic here using the currentText
        // You may want to trigger a search API request or filter your data accordingly
        print("Search text: \(currentText)")
        
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()

            if let searchText = textField.text, !searchText.isEmpty {
                searchLocation(query: searchText)
            }

            return true
        }
}


extension MapViewVC: CLLocationManagerDelegate{

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates if needed
    }
}
