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
    @IBOutlet private weak var leftMenuBtn: UIBarButtonItem?
    @IBOutlet private weak var mapView: MKMapView?
    private var positionViewModel: PositionViewModel?
    private var crewViewModel: CrewViewModel?
    private var issLocation: CLLocation?
    private var pointAnnotation: MKPointAnnotation?
    private var locations: [NSManagedObject] = []
    private var interval = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.Common.iss
        setupMapView()
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PersistentLocations.shared.saveLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initViewModels()
        setupTimer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let locationsLogViewController = segue.destination as? LocationsLogViewController else { return }
    
        locationsLogViewController.locations = locations
    }
    
    private func setupMenu() {
        leftMenuBtn?.target = revealViewController()
        leftMenuBtn?.action = #selector(revealViewController()?.revealSideMenu)
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: interval,
                             repeats: true) { timer in
            self.positionViewModel?.makeRequest()
            self.updateLocation()
        }
    }
    
    private func setupMapView() {
        mapView?.delegate = self
        pointAnnotation = MKPointAnnotation()
        pointAnnotation?.title = Constant.Common.iss
    }
    
    private func initViewModels() {
        positionViewModel = PositionViewModel()
        positionViewModel?.delegate = self
        crewViewModel = CrewViewModel()
    }
    
    private func updateLocation() {
        guard let location = issLocation else { return }
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: Constant.Home.mapZoom,
                                                  longitudinalMeters: Constant.Home.mapZoom)
        
        guard let point = pointAnnotation else { return }
        point.coordinate = coordinate
        saveLocation(location: location)
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.mapView?.addAnnotation(point)
            self.mapView?.setRegion(coordinateRegion, animated: true)
        })
    }
    
    private func saveLocation(location: CLLocation) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: Constant.Home.entityName, in: managedContext)!
            let newLocation = NSManagedObject(entity: entity, insertInto: managedContext)
            
            newLocation.setValue(location.coordinate.latitude,
                                 forKey: Constant.Home.latitudeKey)
            newLocation.setValue(location.coordinate.longitude,
                                 forKey: Constant.Home.longitudeKey)
            
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
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constant.Home.issMarker)
        annotationView.markerTintColor = Constant.Home.issMarkerColor
        annotationView.glyphImage = UIImage(named: Constant.Home.issIcon)
        return annotationView
    }
}

extension HomeViewController: MKAnnotation {
    @objc
    dynamic var coordinate: CLLocationCoordinate2D {
        if let lat = issLocation?.coordinate.latitude,
           let lon = issLocation?.coordinate.longitude {
            let currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            return currentLocation
        }
        // Else, set the user's location
        let currentLocation = Constant.Common.currentLocation
        return currentLocation
    }
}

extension HomeViewController: PositionDelegate {
    func getPosition(latitude: Double, longitude: Double) {
        issLocation = CLLocation(latitude: latitude, longitude: longitude)
        updateLocation()
    }
}

extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> MainViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is MainViewController {
            return viewController! as? MainViewController
        }
        while (!(viewController is MainViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is MainViewController {
            return viewController as? MainViewController
        }
        return nil
    }
}
