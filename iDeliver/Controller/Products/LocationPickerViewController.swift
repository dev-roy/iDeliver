//
//  LocationPickerViewController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class LocationPickerViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private let geoLocation = CLGeocoder()
    private var shouldGetUserLocation = false
    private var currentLocation: CLPlacemark?
    private var currentRegion: CLCircularRegion?
    var onLocationPicked: ((Address) -> Void)?

    private let viewObj = LocationPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUpMain()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setUpMain() {
        title = "Pick a Delivery Location"
        view = viewObj
        viewObj.mapView.delegate = self
        viewObj.setLocationButtonAction = locationButtonAction
        setUpLocationManager()
    }
    
    func locationButtonAction() {
        guard
            let location = currentLocation,
            let onLocationPicked = onLocationPicked
        else { return }
        
        let address = Address(street1: location.name ?? "", street2: location.locality ?? "", city: location.subAdministrativeArea ?? "", state: location.administrativeArea ?? "", zipCode: location.postalCode ?? "", countryOrRegion: location.country ?? "")
        onLocationPicked(address)
        navigationController?.popViewController(animated: true)
    }
    
    func getLocationDetailsFrom(coordinates: CLLocationCoordinate2D, onComplete: (() -> Void)?) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        getLocationDetailsFrom(location: location, onComplete: onComplete)
    }
    
    func setUpLocationManager() {
        viewObj.locationButtonAction = checkLocationPermissions
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getLocationDetailsFrom(location: CLLocation, onComplete: (() -> Void)?) {
        geoLocation.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) in
            if let error = error {
                print("Error in reverse location", error)
                return
            }
            guard
                let placemarks = placemarks,
                let firstLocation = placemarks.first,
                let region = firstLocation.region as? CLCircularRegion
            else { return }
            if region.center.latitude == .zero || region.center.longitude == .zero {
                print("Invalid region?")
                return
            }
            self.currentLocation = firstLocation
            self.currentRegion = region
            self.viewObj.setLocationDescription(location: firstLocation)
            if let onComplete = onComplete { onComplete() }
        }
    }
    
    func checkLocationPermissions() {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        shouldGetUserLocation = true
        executeLocationActionsOnStatus(status: status)
    }
    
    func executeLocationActionsOnStatus(status: CLAuthorizationStatus) {
        if !shouldGetUserLocation { return }
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            let alert = UIAlertController(title: "Location Services Disabled", message: "Turn on location services to see your current location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        default:
            print("Case not contemplated: \(status.rawValue)")
        }
    }

}

extension LocationPickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getLocationDetailsFrom(coordinates: mapView.centerCoordinate, onComplete: nil)
    }
}

extension LocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        executeLocationActionsOnStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        getLocationDetailsFrom(location: locations.first!) { [weak self] () in
            guard let region = self?.currentRegion else { return }
            self?.viewObj.centerMapInRegion(region)
        }
    }
}
