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
    
    private func getCrew(completion: @escaping(Result<Crew, NetworkError>) -> Void) {
        openNotifyViewModel?.requestCrew() { (requestData, requestError) in
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
