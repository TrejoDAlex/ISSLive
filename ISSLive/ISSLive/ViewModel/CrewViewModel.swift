//
//  CrewViewModel.swift
//  ISSLive
//
//  Created by Alex on 2/3/22.
//

import Foundation
import OSLog

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
                  print("Craft:\(craft) Astronaut:\(name)")
              }
          case .failure(let error):
              print(error)
          }
        }
    }
}
