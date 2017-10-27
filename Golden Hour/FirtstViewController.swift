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
    @IBOutlet weak var CurrentLocationLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var goldenHourSunriseLabel: UILabel!
    @IBOutlet weak var goldenHourSunsetLabel: UILabel!
    
     @IBOutlet weak var datumLabel: UILabel!
    
    
    
    
    
    
    let locationManager = CLLocationManager()
    
    @IBAction func changeDate(_ sender: UIButton) {
        alertDateMessage()
        
    }
    
    func alertDateMessage () {
        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        
        alertController.view.addSubview(datePickerView)
        datePickerView.addTarget(self, action: #selector(FirtstViewController.handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            
            let date = formater.string(from: datePickerView.date)
            
            self.datumLabel.text = date
            

        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        let date = formater.string(from: sender.date)
        
        self.datumLabel.text = date
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDateTime = Date ()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        hourLabel.text = "\(dateFormatter.string(from: currentDateTime))"
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        datumLabel.text = "\(dateFormat.string(from: today))"
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
            
        
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        var locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print(locValue.latitude)
        
        var location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                print(pm.locality!)
                self.CurrentLocationLabel.text = "\(pm.locality!), \(pm.country!)"
                print(pm.timeZone!)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
        
        func getData() {
            
            let url = URL(string: "https://api.sunrise-sunset.org/json?lat=\(locValue.latitude)&lng=\(locValue.longitude)&formatted=0")
            print(url)
            let task = URLSession.shared.dataTask(with: url!) {
                data, _, error in
                guard let responseData = data, error == nil else {
                    return
                }
                
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                
                
                do {
                    let result = try decoder.decode(ApiResult.self, from: responseData)
                    let time = result.results
                    
                    let displaySunset = time!.sunset!
                    let displaySunrise = time!.sunrise!
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .short
                    //dateFormatter.timeZone = NSTimeZone(name: "UTC+02")! as TimeZone
                    
                    var goldenHourSunsetTop = time!.sunset!.addingTimeInterval(1800)
                    var goldenHourSunsetBottom = time!.sunset!.addingTimeInterval(-1800)
                    var goldenHourSunriseTop = time!.sunrise!.addingTimeInterval(1800)
                    var goldenHourSunriseBottom = time!.sunrise!.addingTimeInterval(-1800)
                    print("\(goldenHourSunsetBottom)")
                    
                    DispatchQueue.main.async {
                        self.sunsetLabel.text = dateFormatter.string(from:displaySunset)
                        self.sunriseLabel.text = dateFormatter.string(from:displaySunrise)
                        self.goldenHourSunsetLabel.text = "\(dateFormatter.string(from: goldenHourSunsetBottom)) - \(dateFormatter.string(from:goldenHourSunsetTop)) "
                        self.goldenHourSunriseLabel.text = "\(dateFormatter.string(from: goldenHourSunriseBottom)) - \(dateFormatter.string(from:goldenHourSunriseTop)) "
                        
                        
                    }
                    
                    
                    
                    
                } catch {
                    print(error)
                }
            }
            
            task.resume()
        }
        
        getData()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(FirtstViewController.applicationapplicationWillEnterForeground(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
        
    }
    
    
    @objc func applicationapplicationWillEnterForeground(notification: NSNotification)
    {
        locationManager.requestLocation()
        print("location changed")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
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
