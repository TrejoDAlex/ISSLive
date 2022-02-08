//
//  ViewController.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import UIKit
import os.log
import MapKit

/// Displays the International Space Station location on a MKMapView, the ISS location is updated every 10 seconds.
final class HomeViewController: UIViewController {
    
    private var positionViewModel: PositionViewModel?
    private var crewViewModel: CrewViewModel?
    private var issLocation: CLLocation?
    
    @IBOutlet private weak var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        initViewModels()
        setupTimer()
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { timer in
            self.positionViewModel?.makeRequest()
            self.updateLocation()
        }
    }
    
    private func setupMapView() {
        mapView?.delegate = self
    }
    
    private func initViewModels() {
        positionViewModel = PositionViewModel()
        positionViewModel?.delegate = self
        crewViewModel = CrewViewModel()
    }
    
    private func updateLocation() {
        guard let location = issLocation else { return }
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: Constant.mapZoom, longitudinalMeters: Constant.mapZoom)
        let pointAnnotation = MKPointAnnotation()
    
        pointAnnotation.title = Constant.issAnnotationTitle
        pointAnnotation.coordinate = coordinate
        print("Coordinate: \(coordinate)")
        
        mapView?.addAnnotation(pointAnnotation)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constant.issMarker)
        annotationView.markerTintColor = Constant.issMarkerColor
        annotationView.glyphImage = UIImage(named: Constant.issIcon)
        return annotationView
    }
}

extension HomeViewController: MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        
        if let lat = issLocation?.coordinate.latitude,
           let lon = issLocation?.coordinate.longitude {
            let currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            return currentLocation
        }
        // Else, set the user's location
        let currentLocation = CLLocationCoordinate2D(latitude: 19.01999992, longitude: -98.62333084)
        return currentLocation
    }
}

extension HomeViewController: PositionDelegate {
    func getPosition(latitude: Double, longitude: Double, timestamp: Int) {
        issLocation = CLLocation(latitude: latitude, longitude: longitude)
        updateLocation()
    }
}
