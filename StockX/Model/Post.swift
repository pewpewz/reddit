//
//  Post.swift
//  StockX
//
//  Created by terrylee on 4/8/21.
//

import Foundation


/// Swift structs map to Reddit's Json data structure
struct Listing:Decodable {
    var data: Data
}

extension Listing {
    func getPosts() -> [Post] {
        data.children.map { $0.data }
    }
}

struct Data:Decodable {
    var children: [Child] = []
}

struct Child:Decodable {
    var data:Post
}

struct Post:Decodable {
    var title:String
    var subreddit:String
    var url:String
}
