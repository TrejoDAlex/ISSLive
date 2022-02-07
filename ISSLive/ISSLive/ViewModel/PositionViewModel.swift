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

protocol PositionProtocol {
    
}

struct PositionViewModel {
   
    private var openNotifyViewModel: OpenNotifyViewModel?
    
    init() {
        openNotifyViewModel = OpenNotifyViewModel()

        guard let url = URL(string: openNotifyViewModel?.positionURL ?? "") else { return }
        let request = URLRequest(url: url)
        
        openNotifyViewModel?.makeUrlRequest(request) { (result: Result<Position, NetworkError>) in
          switch result {
          case .success(let iss):
              let lon = iss.issPosition.longitude
              let lat = iss.issPosition.latitude
              let timestamp = iss.timestamp
              print("ISS Position: /n Longitude:\(lon) /n Latitude:\(lat) /nTimestamp:\(timestamp)")
          case .failure(let error):
              print(error)
          }
        }
    }
}
