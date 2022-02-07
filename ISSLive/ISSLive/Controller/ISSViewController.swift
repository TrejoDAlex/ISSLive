//
//  ViewController.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import UIKit
import os.log
import MapKit

final class ISSViewController: UIViewController {
    
    private var positionViewModel: PositionViewModel?
    private var crewViewModel: CrewViewModel?
    
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        initViewModels()
        
        let initialLocation = CLLocation(latitude: 19.01999992, longitude: -98.62333084)
        updateLocation(initialLocation)
    }
    
    private func initViewModels() {
        positionViewModel = PositionViewModel()
        crewViewModel = CrewViewModel()
    }
    
    private func updateLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
//        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 400000)
        let pointAnnotation = MKPointAnnotation()
    
        pointAnnotation.title = "ISS"
        pointAnnotation.coordinate = coordinate
        
        mapView.addAnnotation(pointAnnotation)
//        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: coordinateRegion), animated: true)
//        mapView.setCameraZoomRange(zoomRange, animated: true)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ISSViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = UIColor(red: (69.0/255), green: (95.0/255), blue: (170.0/255), alpha: 1.0)
        annotationView.glyphImage = UIImage(named: "spaceStation")
        return annotationView
    }
}

extension ISSViewController: MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        let popocatepetlLocation = CLLocationCoordinate2D(latitude: 19.01999992, longitude: -98.62333084)
        return popocatepetlLocation
    }
}
//19.01999992 -98.62333084 Popocatepetl
