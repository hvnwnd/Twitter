//
//  Tweet.swift
//  Twitter
//
//  Created by Bin CHEN on 13/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let twitterFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let displayFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY HH:ss"
        return formatter
    }()
}

struct HashTag : Decodable {
    var text : String?
}

struct Entity : Decodable {
    var hashTags : [HashTag]?
    
    enum CodingKeys: String, CodingKey {
        case hashTags = "hashtags"
    }
}

struct Tweet : Decodable{
    var text : String?
    var date : Date?
    var retweetCount : Int?
    var entity : Entity?
    
    enum CodingKeys: String, CodingKey {
        case text
        case date = "created_at"
        case retweetCount = "retweet_count"
        case entity = "entities"
    }
    
    func sharedText() -> String? {

        guard text != nil,date != nil else {
            return nil
        }
        return "Le \(date), @SkyrockFM a tweeté : \(text)"
        
        //[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]];

    }
}

