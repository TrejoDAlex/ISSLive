//
//  CrewViewModel.swift
//  ISSLive
//
//  Created by Alex on 2/3/22.
//

import Foundation
import os

/// Makes requests to the api, in order to get the current number of people in space.
///  When known it also returns the names and spacecraft those people are on.
///  This API takes no inputs in. Then, notifies the view through binding,
///  in order to update the UI data.
struct CrewViewModel {
    
    private var openNotifyViewModel: OpenNotifyViewModel?
    
    init() {
        openNotifyViewModel = OpenNotifyViewModel()
        
        guard let url = URL(string: openNotifyViewModel?.crewURL ?? "") else { return }
        let request = URLRequest(url: url)
        
        openNotifyViewModel?.makeUrlRequest(request) { (result: Result<Crew, NetworkError>) in
          switch result {
          case .success(let crew):
              for astronaut in crew.people {
                  let craft = astronaut.craft
                  let name = astronaut.name
              }
          case .failure(let error):
              if #available(iOS 14.0, *) {
                  os_log("\(error.localizedDescription)")
              } else {
                  // Fallback on earlier versions
              }
          }
        }
    }
}
