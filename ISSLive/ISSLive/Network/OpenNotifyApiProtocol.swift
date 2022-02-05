//
//  OpenNotifyApiProtocol.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import Foundation
import UIKit

protocol OpenNotifyApiProtocol {
    var positionURL: String { get }
    var crewURL: String { get }
    func makeUrlRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}

extension OpenNotifyApiProtocol {
    var positionURL: String { "http://api.open-notify.org/iss-now.json?" }
    var crewURL: String { "http://api.open-notify.org/astros.json?" }
}

enum NetworkError: Error {
    case badURL
    case errorData
}
