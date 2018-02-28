//
//  ViewController.swift
//  ISS Passes
//
//  Created by Jeremy Braud on 2/19/18.
//  Copyright © 2018 JPMC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitudeLbl: UILabel!
    
    @IBOutlet weak var longitudeLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var passes = [PassModel]()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
        findCoordinates()
    }
    

    func findCoordinates() {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            if let currentLocation = locationManager.location {
                activityIndicator.startAnimating()
                
                print("Longitude \(currentLocation.coordinate.longitude) \n")
                print("Latitude \(currentLocation.coordinate.latitude)")
                
                
                longitudeLbl.text = "\(currentLocation.coordinate.longitude)"
                latitudeLbl.text = "\(currentLocation.coordinate.latitude)"
                
                getISSPasses("\(currentLocation.coordinate.longitude)", lat: "\(currentLocation.coordinate.latitude)")
            } else {
                longitudeLbl.text = "30.0"
                latitudeLbl.text = "45.0"
                getISSPasses("30.0", lat: "45.0")
        }
        }
    }
    
    func getISSPasses(_ lon : String , lat : String){
        ServiceCalls.sharedInstance.getPasses(lon: lon, lat: lat, success: { (passes) in
            self.passes = passes
            self.tableView.reloadData()
            self.tableView.sizeToFit()
            self.activityIndicator.stopAnimating()
        }) { (dataTask, error) in
            self.activityIndicator.stopAnimating()
            
            // Show user an alert if we did not receive a successful response from the API.
            let alertController = UIAlertController(title: "Sorry", message: error?.localizedDescription ?? "Could not retrieve ISS passes from server.", preferredStyle: .alert)
            
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okBtn)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to find the ISS, we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell") as! PassTableViewCell
        let pass = passes[indexPath.row]
        
        cell.dateLabel.text = pass.risetime
        if let duration = pass.duration {
            cell.durationLabel.text = "\(duration) second\(duration == 1 ? "" : "s")"
        }
        
        return cell
    }
}

