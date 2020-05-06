//
//  LocationPickerView.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import MapKit
import UIKit

class LocationPickerView: UIView {
    var locationButtonAction: (() -> Void)?
    var setLocationButtonAction: (() -> Void)?
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isAccessibilityElement = true
        map.accessibilityHint = "Map"
        return map
    }()
    
    private let pinImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "mappin"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleCard: TextCard = {
        let card = TextCard()
        return card
    }()

    private let userLocationButton: IconButtonCard = {
        let button = IconButtonCard()
        return button
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Location", for: .normal)
        button.addTarget(self, action: #selector(onLocationSet), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpMainLayout() {
        backgroundColor = .white
        setUpMap()
        setUpMapContents()
    }
    
    func setUpMap() {
        addSubview(mapView)
        let safeMargins = layoutMarginsGuide
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
    }
    
    func setUpMapContents() {
        mapView.addSubview(titleCard)
        userLocationButton.setUpButton(iconName: "location", action: getUserLocation)
        mapView.addSubview(userLocationButton)
        mapView.addSubview(pinImage)
        mapView.addSubview(selectButton)
        mapView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        
        let margins = mapView.layoutMarginsGuide
        titleCard.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor).isActive = true
        titleCard.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        titleCard.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        userLocationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        userLocationButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        selectButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        pinImage.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
        pinImage.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        pinImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pinImage.widthAnchor.constraint(equalTo: pinImage.heightAnchor).isActive = true
    }
    
    func getUserLocation() {
        if let action = locationButtonAction { action() }
    }
    
    func setLocationDescription(location: CLPlacemark) {
        let stringContent = NSMutableAttributedString()
        if let locality = location.locality, let country = location.country {
            stringContent.append(NSAttributedString(
                string: "\(locality) - \(country)\n",
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
                ])
            )
        }
        if let administrativeArea = location.administrativeArea, let subAdministrativeArea = location.subAdministrativeArea {
            stringContent.append(NSAttributedString(
                string: "\(administrativeArea) - \(subAdministrativeArea)\n",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                    NSAttributedString.Key.foregroundColor: UIColor.systemGray
                ])
            )
        }
        if let name = location.name {
            stringContent.append(NSAttributedString(
                string: name,
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                ])
            )
        }
        titleCard.setTitle(stringContent)
    }
    
    func centerMapInRegion(_ region: CLCircularRegion) {
        let radius = region.radius * 2
        let region = MKCoordinateRegion(center: region.center, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
    
    @objc
    func onLocationSet() {
        if let action = setLocationButtonAction { action() }
    }
    
}
