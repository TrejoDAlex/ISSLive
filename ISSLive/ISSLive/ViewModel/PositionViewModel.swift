//
//  PositionViewModel.swift
//  ISSLive
//
//  Created by Alex on 2/3/22.
//

import Foundation
import os

///  Makes requests to the api, it returns the current location of the ISS.
///  It returns the current latitude and longitude of the space station
///  with a unix timestamp for the time the location was valid. This API takes no inputs.
///  Then, notifies the view through binding, in order to update the UI data.

protocol PositionDelegate {
    func getPosition(latitude: Double, longitude: Double, timestamp: Int)
}

class PositionViewModel {
   
    private var openNotifyViewModel: OpenNotifyViewModel?
    var delegate: PositionDelegate?
    
    init() {
        openNotifyViewModel = OpenNotifyViewModel()

        guard let url = URL(string: self.openNotifyViewModel?.positionURL ?? "") else { return }
        let request = URLRequest(url: url)
        
        openNotifyViewModel?.makeUrlRequest(request) { (result: Result<Position, NetworkError>) in
          switch result {
          case .success(let iss):
              if let lat = Double(iss.issPosition.latitude),
                 let lon = Double(iss.issPosition.longitude) {
                  self.delegate?.getPosition(latitude: lat, longitude: lon, timestamp: iss.timestamp)
              }
          case .failure(let error):
              os_log("\(error.localizedDescription)")
          }
        }
    }
}
