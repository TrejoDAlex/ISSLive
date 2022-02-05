//
//  OpenNotifyClient.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import Foundation
import OSLog

final class OpenNotifyViewModel: OpenNotifyApiProtocol {
    
    func makeUrlRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let urlTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

        if let errorFound = error {
            os_log(.error, "Unexpected error %@", [errorFound])
            completion(.failure(.badURL))
            return
        }

        guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
            completion(.failure(.badURL))
            return
        }

        guard let data = data else {
            completion(.failure(.errorData))
            return
        }

        do {
            let issPosition = try JSONDecoder().decode(T.self, from: data)
                completion(.success(issPosition))
            } catch {
                completion(.failure(.errorData))
            }
        }

        urlTask.resume()
    }
}
