//
//  RedditViewModel.swift
//  StockX
//
//  Created by terrylee on 4/8/21.
//

import Foundation

protocol RedditDelegate {
    var posts:[Post] {get set}
}

class RedditViewModel {
    let baseURL = "https://www.reddit.com/"
    var delegate: RedditDelegate?
    var network = Network()
    typealias CompletionBlock = (Result<Bool>) -> ()
    
    /// Fetches Reddit's Json Data
    /// - Parameters:
    ///   - subReddit: subreddit to search
    ///   - completion: fetch status result
    public func searchSubReddit(_ subReddit:String, completion:@escaping CompletionBlock) {
        let text = subReddit.trimmingCharacters(in: .whitespacesAndNewlines)
        let format = text.isEmpty ? text : "r/"+text
        let urlString = baseURL+format+"/.json"
        
        network.networkCall(url: urlString) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.httpResponse(result: posts)
                completion(Result.success(true))
            case .failure(_):
                completion(Result.success(false))
            }
        }
    }
    
    /// Updates list view with fetched result
    /// - Parameter result: Reddit's subreddit result
    private func httpResponse(result: [Post]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.posts = result
        }
    }
}
