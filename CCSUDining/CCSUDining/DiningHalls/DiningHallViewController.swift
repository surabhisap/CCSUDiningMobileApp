//
//  FirstViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 2/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import MapKit

class DiningHallViewController: UIViewController {
    
    @IBOutlet weak var diningTableView: UITableView!
    let viewModel = DinerViewModel()
    var diningHallArray = [String]()
    var menuArray = [String: [MenuModel]]()
    var dinerReviewsArray = [String: ReviewsModel]()
    var selectedDinerIndex = 0
    private var dinerRatingDictionary = [String: String]()
    private var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    private var currentUser: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAndPopulateDinerData()
        configureLocationManager()
        
    }
    
    private func getAndPopulateDinerData() {
        
        viewModel.getMenuForToday(completionHandler: { [weak self] (menuModelArray) in
            self?.menuArray = menuModelArray
            self?.diningHallArray = [String] (menuModelArray.keys)
            
            APIManager().fetchDinerReviews { [weak self] (dinerReviews) in
                self?.dinerReviewsArray = dinerReviews
                for diner in dinerReviews {
                    guard let allReviews = diner.value.reviews else {
                        return
                    }
                    
                    var totalReviews = 0
                    for review in allReviews {
                        totalReviews += Int(review.rating ?? "0") ?? 0
                    }
                    self?.dinerRatingDictionary[diner.key] = allReviews.count == 0 ? "0" : "\(totalReviews / allReviews.count)"
                }
                self?.diningTableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            if let menuViewController = segue.destination as? MenuViewController {
                
                if let menuArray = menuArray[diningHallArray[selectedDinerIndex]]?.group(by: { $0.meal ?? "" }) {
                    menuViewController.menuItemsArray = menuArray
                    menuViewController.currentUser = currentUser
                }
            }
        } else if segue.identifier == "dinerReviews" {
            if let dinerReviewsViewController = segue.destination as? DinerReviewsViewController, let tag = (sender as? UIButton)?.tag {
                dinerReviewsViewController.dinerName = diningHallArray[tag]
                dinerReviewsViewController.dinerRating = dinerRatingDictionary[diningHallArray[tag]] ?? "0"
                dinerReviewsViewController.closure = { [weak self] in
                    self?.getAndPopulateDinerData()
                }
            }
        }
    }
    
    @objc private func addReviewAction (sender: UIButton) {
        performSegue(withIdentifier: "dinerReviews", sender: sender)
    }
    
    @objc private func locateDinerAction() {

        let mapOptions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        mapOptions.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default , handler:{ [weak self] (UIAlertAction)in
            self?.openDirectionsInAppleMaps()
        }))
        
        mapOptions.addAction(UIAlertAction(title: "Open in Google Maps", style: .default , handler:{ [weak self] (UIAlertAction)in
            self?.openDirectionsInGoogleMaps()
        }))
        
        mapOptions.addAction(UIAlertAction(title: "Dismiss", style: .cancel , handler:{ (UIAlertAction)in
        }))
        
        self.present(mapOptions, animated: true, completion: nil)
    }
    
    private func getCurrentUser() {
        
        APIManager.shared.fetchCurrentUser { [weak self] (currentUser) in
            self?.currentUser = currentUser
        }
    }
    
}


extension DiningHallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return diningHallArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "diningHallCell", for: indexPath) as? DiningHallCell else {
            return UITableViewCell()
        }
        
        cell.dinerNameLabel.text = DiningHallType(rawValue: diningHallArray[indexPath.row])?.hallName
        cell.addReviewButton.addTarget(self, action: #selector(addReviewAction), for: .touchUpInside)
        cell.locateDinerButton.addTarget(self, action: #selector(locateDinerAction), for: .touchUpInside)
        cell.dinerRatingView.rating = Double(dinerRatingDictionary[diningHallArray[indexPath.row]]!)!
        cell.addReviewButton.setTitle("Add Reviews(\(dinerReviewsArray[diningHallArray[indexPath.row]]?.reviews?.count ?? 0))", for: .normal)
        cell.dinerImageView.image = UIImage(named: diningHallArray[indexPath.row])
        cell.addReviewButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDinerIndex = indexPath.row
        performSegue(withIdentifier: "menuSegue", sender: self)
    }
}

enum DiningHallType: String, CaseIterable {
    
    case hilltop_cafe = "hilltop_cafe"
    case memorial_hall = "memorial_hall"
    case devils_den = "devils_den"
    case Starbucks = "Starbucks"
    
    var hallName: String {
        switch self {
        case .hilltop_cafe:
            return "Hilltop Cafe"
        case .memorial_hall:
            return "Memorial Hall"
        case .devils_den:
            return "Devil's Den"
        case .Starbucks:
            return "Starbucks"
        }
    }
    
    func getDinerLatLong() -> CLLocationCoordinate2D {
        switch self {
        case .hilltop_cafe:
            return CLLocationCoordinate2D(latitude: 41.6938183, longitude: -72.7637449)
        case .memorial_hall:
            return CLLocationCoordinate2D(latitude: 41.691544, longitude: -72.767723)
        case .devils_den:
            return CLLocationCoordinate2D(latitude: 41.692188, longitude: -72.767914)
        case .Starbucks:
            return CLLocationCoordinate2D(latitude: 41.6931, longitude: -72.7642)
        }
    }
    
}

extension DiningHallViewController: CLLocationManagerDelegate {
    
    private func configureLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func openDirectionsInGoogleMaps() {
        
        guard let selectedDinerCoordinate = DiningHallType(rawValue: diningHallArray[selectedDinerIndex])?.getDinerLatLong() else { return }
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(selectedDinerCoordinate.latitude),\(selectedDinerCoordinate.longitude)&directionsmode=walking") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func openDirectionsInAppleMaps() {
        
        guard let currentLocation = locationManager.location?.coordinate else { return }
        guard let selectedDinerCoordinate = DiningHallType(rawValue: diningHallArray[selectedDinerIndex])?.getDinerLatLong() else { return }
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)))
        source.name = "Current Location"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedDinerCoordinate.latitude, longitude: selectedDinerCoordinate.longitude)))
        destination.name = DiningHallType(rawValue: diningHallArray[selectedDinerIndex])?.hallName
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
}
