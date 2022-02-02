//
//  Position.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import Foundation

struct Position: Codable {
    let issPosition: ISSPosition
    let timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case issPosition = "iss_position"
        case timestamp
    }
}

struct ISSPosition: Codable {
    let longitude: String
    let latitude: String
}
