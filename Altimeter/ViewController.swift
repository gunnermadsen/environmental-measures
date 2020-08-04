//
//  ViewController.swift
//  Altimeter
//
//  Created by gunner madsen on 8/3/20.
//  Copyright © 2020 Gunner Madsen. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var relativeAltitude: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    private let locationManager: CLLocationManager = CLLocationManager()
    let altimeter = CMAltimeter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        updateAltimeterMetrics()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            var altitude = lastLocation.altitude
            altitude = altitude * 3.281
            let alt = "My altitude is \(String(format: "%.2f", altitude)) feet"
            altitudeLabel.text = alt
            
            let latitude = "Latitude: \(String(lastLocation.coordinate.latitude))"
            let longitute = "Longitude: \(String(lastLocation.coordinate.longitude))"
            
            latitudeLabel.text = latitude
            longitudeLabel.text = longitute
        }
    }
    
    func updateAltimeterMetrics() {
        // check if barometer is available
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                let relativeAltitude = data?.relativeAltitude.floatValue
                let pressure = data?.pressure.floatValue
                
                self.relativeAltitude.text = String.init(format: "%.1fM", relativeAltitude!)
                self.pressure.text = String.init(format: "%.2f hPA", pressure!)
            })
        }
    }

}
