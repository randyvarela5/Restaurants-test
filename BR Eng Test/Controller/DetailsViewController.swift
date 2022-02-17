//
//  DetailsViewController.swift
//  BR Eng Test
//
//  Created by Randy Varela on 1/26/22.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    
    var restaurant: Restaurant?
    var coordinate = CLLocationCoordinate2D()
    let restaurantAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lunch Tyme"
        configureItems()
        centerViewOnLocation()
        
        //MARK: - Passing in restaurant details from cell user selected
        
        restaurantNameLabel.text = restaurant?.name
        categoryTypeLabel.text = restaurant?.category ?? "no category"
        restaurantAddressLabel.text = restaurant?.location.formattedAddress.joined(separator: ", ")
        phoneNumberLabel.text = restaurant?.contact?.formattedPhone ?? "no phone number"
        twitterLabel.text = ("@\(restaurant?.contact?.twitter ?? "No twitter")")
    }
    
    //MARK: - Passing in restaurant coordinates to map
    
    private func centerViewOnLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: restaurant?.location.lat ?? 0.0, longitude: restaurant?.location.lng ?? 0.0)
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            mapView.setRegion(region, animated: true)
            restaurantAnnotation.coordinate = coordinate
            mapView.addAnnotation(restaurantAnnotation)
    }
    
    //MARK: - navigation bar button items and actions
    
    private func configureItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_webBack"), style: .done, target: self, action: #selector(closeTapped))
   }
    
    @objc private func closeTapped() {
        print("dismiss view")
        self.navigationController?.popViewController(animated: true)
    }
}


