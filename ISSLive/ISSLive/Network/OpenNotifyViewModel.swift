//
//  OpenNotifyClient.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import Foundation

final class OpenNotifyViewModel: OpenNotifyApiProtocol {
    
    func requestPosition(completion: @escaping (Position?, Error?) -> Void) {
        
        guard let url = URL(string: positionURL) else { return }
        URLSession.shared.dataTask(with: url) { (sessionData, _, error) in
        
            if let errorFound = error {
                return completion(nil, errorFound)
            }
            
            guard let data = sessionData else { return }
            
            do {
                let issPosition = try JSONDecoder().decode(Position.self, from: data)
                completion(issPosition, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        
        }.resume()
    }
    
    func requestCrew(completion: @escaping (Crew?, Error?) -> Void) {
        guard let url = URL(string: crewURL) else { return }
        URLSession.shared.dataTask(with: url) { (sessionData, _, error) in
        
            if let errorFound = error {
                return completion(nil, errorFound)
            }
            
            guard let data = sessionData else { return }
            
            do {
                let issCrew = try JSONDecoder().decode(Crew.self, from: data)
                completion(issCrew, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        
        }.resume()
    }
}
