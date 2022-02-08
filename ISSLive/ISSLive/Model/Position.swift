//
//  Position.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import Foundation

///  This struct models the ISS position API response.
struct Position: Codable {
    let issPosition: ISSPosition
    
    enum CodingKeys: String, CodingKey {
        case issPosition = "iss_position"
    }
}

struct ISSPosition: Codable {
    let longitude: String
    let latitude: String
}
