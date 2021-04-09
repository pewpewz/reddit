//
//  Network.swift
//  StockX
//
//  Created by terrylee on 4/8/21.
//

import Foundation

enum Result<R> {
    case success(R)
    case failure(Error)
}

enum Error: Swift.Error {
  case unknownAPIResponse
  case statusCodeError
  case generic
}


class Network {
    /// Maps to Reddit's Json root and return posts
    typealias root = Listing
    typealias dataType = [Post]
    typealias CompletionBlock = (Result<dataType>) -> ()
    
    func networkCall(url: String, completion:@escaping CompletionBlock) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        guard let url = URL(string: url) else {
            completion(.failure(.generic))
            return
        }

        let _ = session.dataTask(with: url) {
            data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data = data else {
                completion(Result.failure(.statusCodeError))
                return
            }
            do {
                let results = try JSONDecoder().decode(root.self, from: data)
                completion(Result.success(results.getPosts()))
            } catch {
                completion(Result.failure(.unknownAPIResponse))
            }
        }.resume()
    }
}
