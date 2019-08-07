//
//  HomeViewController.swift
//  Alamat Task
//
//  Created by prog_zidane on 8/6/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit
import  MapKit
import Firebase
class HomeViewController: UIViewController {

  
    @IBOutlet weak var userLocationContainerView: UIView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var location = ""
    var userLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mapView.delegate = self
        configMapView()

    }
    func configMapView(){

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let pickLocationGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        pickLocationGesture.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(pickLocationGesture)
    }
    @objc func longPress (gestureRecoganizer: UIGestureRecognizer){
        let touchPoint = gestureRecoganizer.location(in: self.mapView)
        let cordinates = mapView.convert(touchPoint ,toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinates
        annotation.title = "Current Location"
        let mylocation = CLLocation(latitude: cordinates.latitude, longitude: cordinates.longitude)
        print(mylocation.coordinate.latitude)
        mapView.addAnnotation(annotation)
        UserServices.shared.translateUserLocation(userLocation: mylocation) { (location) in
            print(location)
            if location != "" {
                self.location  = location
                print(self.location)
            }
        }
        
    }
    @IBAction func didGetCurrentLocationPressed(_ sender: Any) {
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func didUpdateProfilePressed(_ sender: Any) {
        
        if location != "" {
            self.view.showLoader(activityColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
            UserServices.shared.saveProfile( location: location) { (success) in
                self.view.removeLoader()
                if success {
                    SuccessMessage(title: "Success", body: "you have been updated profile and location successfully")
                }
            }
        }else {
            ErrorMessage(title: "Error", body: "You must pick up your location from the map or get current location")
        }
    }
    
    @IBAction func didShowProfilePressed(_ sender: Any) {
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.present( profile,animated: true,completion:nil)
    }
    
}


extension HomeViewController: CLLocationManagerDelegate,MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
        self.locationManager.stopUpdatingLocation()
        UserServices.shared.translateUserLocation(userLocation: userLocation) { (location) in
            if location != "" {
                self.location  = location
                self.userLocationContainerView.isHidden = false
                self.userLocationLabel.text = self.location
            }else{
                self.userLocationContainerView.isHidden = true
            }
        }
        
    }
    
    
}
