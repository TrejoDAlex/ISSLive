//
//  Crew.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import Foundation

///  This struct models the people in space API response.
struct Crew: Codable {
    let people: [People]
}

struct People: Codable {
    let craft: String
    let name: String
}
