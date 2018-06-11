//
//  DetailViewController.swift
//  Searcha
//
//  Created by 施馨檸 on 2018/6/8.
//  Copyright © 2018 施馨檸. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var name:String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var address: String?
    var distance: Int?
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        locationLabel.text = address
        categoryLabel.text = category
        
        if let distance = distance, distance >= 1000 {
            distanceLabel.text = "\(distance/1000)km"
        } else {
            distanceLabel.text = "\(distance!)m"
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        mapView.region = MKCoordinateRegion(center: coordinate, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        
        mapView.addAnnotation(annotation)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
