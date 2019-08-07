//
//  User.swift
//  Alamat Task
//
//  Created by prog_zidane on 8/6/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import Firebase
import MapKit
import CoreLocation


struct UserProfile {
    var uid :String?
    var userName :String?
    var password: String?
    var location:String?
    var token: String?
}

enum UserServices {
    case shared
    func registerNewUser(email:String, password:String,complation:@escaping(_ success:Bool,_ errorMessage : String)->()){
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                
                complation(true,"")
            }else {
                complation(false,(error!.localizedDescription))
            }
        }
        
    }
    
    func login(email:String, password:String,complation:@escaping(_ success:Bool,_ errorMessage : String)->()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                complation(true,"")
                
            }else {
                complation(false,(error?.localizedDescription)!)
            }
        }
    }
    func saveProfile(location : String?, completion: @escaping ((_ success:Bool)->()))
    {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                 guard let email = Auth.auth().currentUser?.email else {return}
                //Auth.a
                let databaseRef = Database.database().reference().child("users/profile/\(uid)")
                let userObject = [
                    "email":email,
                    "password": UserDefaults.standard.string(forKey: "password") ?? "" ,
                    "location": location ?? "",
                    "token": UserDefaults.standard.string(forKey: "FCMToken") ?? "" //FCMToken ,
                    ] as [String:Any]
                databaseRef.setValue(userObject) { (error, ref) in
                    completion(error == nil)
               
            
        }
        
    }
  
    
    func getUserToken(){
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                UserDefaults.standard.set(result.token, forKey: "FCMToken")
            }
        })
    }
    func translateUserLocation(userLocation:CLLocation,complation:@escaping(_ location:String)->()){
        CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
            
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            complation(reversedGeoLocation.formattedAddress)
            
        }
        
    }
    func checkUser()->Bool{
        return UserDefaults.standard.bool(forKey: "email")
    }
    func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            print("in observe")
            if let dict = snapshot.value as? [String:Any],
                let username = dict["email"] as? String,
                let password = dict["password"] as? String,
                let token = dict["token"] as? String,
                let location = dict["location"] as? String
                 {
                print(username  )
                userProfile = UserProfile(uid: snapshot.key, userName: username, password: password, location: location, token: token)
            }
            
            completion(userProfile)
        })
    }
}



struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    var formattedAddress: String {
        return "\(name) , \(city) , \(country)"
    }
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
