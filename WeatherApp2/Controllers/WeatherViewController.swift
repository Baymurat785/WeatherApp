//
//  ViewController.swift
//  WeatherApp2
//
//  Created by Baymurat Abdumuratov on 19/11/23.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController{
 

    @IBOutlet weak var segmnetControl: UISegmentedControl! //Adding segment control
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempuratureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tempSymbol: UILabel!
    
    var celsius: Double = 0
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self //that way weather manager's delegate property is not nil
        searchTextField.delegate = self
    }
    
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //Adding segment control
    @IBAction func segmentControlPressed(_ sender: UISegmentedControl) {
        switch segmnetControl.selectedSegmentIndex{
        case 0:
            tempuratureLabel.text = String(format: "%.1f", celsius)
            tempSymbol.text = "C"
            break
        case 1:
            let fahrenheit = (celsius * 9/5) + 32
            tempuratureLabel.text = String(format: "%.1f", fahrenheit)
            tempSymbol.text = "F"
            break
            
        default:
            
            break
        }
    }
    
    
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController:UITextFieldDelegate{
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)// It is for removing the keyboead from the screen
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // It is for removing the keyboead from the screen
        return true
        
    } // without delegate this function will be useless. Delegate will be notify "Ey view controller, Return keyword was pressed, what should we do? "

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {//this function is useful when you need to work with some validations
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Write someting"
            return false
        }
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) { //Delegate will notify "ey viewcontroller text was ended editing at that moment we need to initialize textField to empty string "
        if let city = searchTextField.text{
            weatherManager.fetchData(cityName: city)
        }
        
        searchTextField.text = ""
        
        
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
        tempuratureLabel.text    = weather.temperatureString
        cityLabel.text           = weather.cityName
            conditionImageView.image = UIImage(systemName: weather.conditonName)  //This will help for setting image for imageView
//            UIImage(named: weather.conditonName)
            celsius = weather.temperature
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation() //this will be needed when you press location button. I did not get it. Maybe, it will be understandable in the future
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchData(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
