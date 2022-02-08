//
//  ViewController.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import UIKit
import os.log
import MapKit
import CoreData

/// Displays the International Space Station location on a MKMapView, the ISS location is updated every 10 seconds.
final class HomeViewController: UIViewController {
    
    private var positionViewModel: PositionViewModel?
    private var crewViewModel: CrewViewModel?
    private var issLocation: CLLocation?
    private var pointAnnotation: MKPointAnnotation?
    var locations: [NSManagedObject] = []
    
    @IBOutlet private weak var mapView: MKMapView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        initViewModels()
        setupTimer()
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.positionViewModel?.makeRequest()
            self.updateLocation()
        }
    }
    
    private func setupMapView() {
        mapView?.delegate = self
        pointAnnotation = MKPointAnnotation()
        pointAnnotation?.title = Constant.issAnnotationTitle
    }
    
    private func initViewModels() {
        positionViewModel = PositionViewModel()
        positionViewModel?.delegate = self
        crewViewModel = CrewViewModel()
    }
    
    private func updateLocation() {
        guard let location = issLocation else { return }
        saveLocation(location: location)
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: Constant.mapZoom, longitudinalMeters: Constant.mapZoom)
        
        guard let point = pointAnnotation else { return }
        point.coordinate = coordinate
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.mapView?.addAnnotation(point)
            self.mapView?.setRegion(coordinateRegion, animated: true)
        })
    }
    
    private func saveLocation(location: CLLocation) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
            let newLocation = NSManagedObject(entity: entity, insertInto: managedContext)
            
            newLocation.setValue(location.coordinate.latitude, forKey: "latitude")
            newLocation.setValue(location.coordinate.longitude, forKey: "longitude")
            
            do {
                try managedContext.save()
                self.locations.append(newLocation)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
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
