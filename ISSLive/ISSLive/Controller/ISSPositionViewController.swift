//
//  ViewController.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import UIKit
import os.log

final class ISSPositionViewController: UIViewController {

    private var openNotifyClient = OpenNotifyClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getPosition() { (result) in
            switch result {
            case .success(let iss):
                let lon = iss.issPosition.longitude
                let lat = iss.issPosition.latitude
                let timestamp = iss.timestamp
                print("ISS Position: /n Longitude:\(lon) /n Latitude:\(lat) /n Timestamp:\(timestamp)")
            case .failure(let failure):
                os_log(.error, "Unexpected error %@", [failure])
            }
        }
        
        getCrew() { (result) in
            switch result {
            case .success(let crew):
                for astronaut in crew.people {
                    let craft = astronaut.craft
                    let name = astronaut.name
                    print("Craft:\(craft) Astronaut:\(name)")
                }
            case .failure(let failure):
                os_log(.error, "Unexpected error %@", [failure])
            }
        }
    }
    

    private func getPosition(completion: @escaping(Result<Position, NetworkError>) -> Void) {
        openNotifyClient.requestPosition() { (requestData, requestError) in
            if let errorFound = requestError {
                os_log(.error, "Unexpected error %@", [errorFound])
                completion(.failure(.badURL))
                return
            }
            guard let issPosition = requestData else {
                completion(.failure(.errorData))
                return
            }
            completion(.success(issPosition))
        }
    }
    
    private func getCrew(completion: @escaping(Result<Crew, NetworkError>) -> Void) {
        openNotifyClient.requestCrew() { (requestData, requestError) in
            if let errorFound = requestError {
                os_log(.error, "Unexpected error %@", [errorFound])
                completion(.failure(.badURL))
                return
            }
            guard let issPosition = requestData else {
                completion(.failure(.errorData))
                return
            }
            completion(.success(issPosition))
        }
    }
}

