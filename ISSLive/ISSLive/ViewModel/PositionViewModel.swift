//
//  PositionViewModel.swift
//  ISSLive
//
//  Created by Alex on 2/3/22.
//
// Makes requests to the api, and receives its response. Then notifies the view through binding,
// in order to update the UI data.

import Foundation
import OSLog

struct PositionViewModel {
   
    private var openNotifyViewModel: OpenNotifyViewModel?
    
    init() {
        openNotifyViewModel = OpenNotifyViewModel()
        
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
    }
    
    private func getPosition(completion: @escaping(Result<Position, NetworkError>) -> Void) {
        openNotifyViewModel?.requestPosition() { (requestData, requestError) in
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
