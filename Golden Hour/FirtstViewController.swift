//
//  FirtstViewController.swift
//  Golden Hour
//
//  Created by vdab cursist on 23/10/2017.
//  Copyright © 2017 vdab cursist. All rights reserved.
//

import UIKit
import CoreLocation

class FirtstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var hourLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    @IBAction func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError!) {
        print("Error while updating locationg" + error.localizedDescription)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentDateTime = Date ()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        
        hourLabel.text = "\(dateFormatter.string(from: currentDateTime))"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
