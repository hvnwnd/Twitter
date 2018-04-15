//
//  NetworkService.swift
//  Twitter
//
//  Created by Bin CHEN on 13/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum TwitterUrl {
    static let token = "https://api.twitter.com/oauth2/token"
    static let search = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    static let tweet = ""
}

enum Credentials {
    static let apiKey = "2zWlaPsP7Nsd7dLR1DoPNdtqu"
    static let secret = "TX1zRGoJKRH1Pe5KzK3pGUXP17hqHfJoKCDje8InFzUCR5pj5O"
}

enum Search {
    static let defaultUser = "skyrockfm"
    static let defaultLimit = 20
}

final class NetworkService {
    fileprivate let sessionManager = Alamofire.SessionManager.default
    fileprivate var currentToken : String?
    fileprivate var disposeBag = DisposeBag()
    
    public func fetchTweets(user : String = Search.defaultUser, count : Int = Search.defaultLimit) -> Observable<[Tweet]> {
        return Observable.create{ observer in
            self.fetchToken()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { _ in
                let parameters = self.searchParameters(user: user, count: count)
                self.sessionManager.request(TwitterUrl.search,
                                             method: HTTPMethod.get,
                                             parameters: parameters,
                                             headers: self.apiHeaders())
                    .responseJSON { response in
                        switch(response.result) {
                        case .success(_):
                            do {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .formatted(DateFormatter.twitterFormat)
                                let tweets = try decoder.decode([Tweet].self, from: response.data!)
                                observer.onNext(tweets)
                            }catch{
                                observer.onError(error)
                            }
                        case .failure(let e):
                            observer.onError(e)
                        }
                }
            }, onError: { e in
                observer.onError(e)
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }

    fileprivate func fetchToken() -> Observable<String> {
        return Observable.create{ observer in
            if self.currentToken != nil {
                observer.onNext(self.currentToken!)
                observer.onCompleted()
            }else{
                let request = self.sessionManager.request(TwitterUrl.token,
                                            method: HTTPMethod.post,
                                            parameters : self.tokenParameters(),
                                            headers: self.headerCredentials())
                    .responseJSON { response in
                        switch(response.result) {
                        case .success(let v) :
                            let token = v as! [String : String]
                            self.currentToken = token["access_token"]
                            observer.onNext(self.currentToken!)
                            observer.onCompleted()
                        case .failure(let e) :
                            observer.onError(e)
                        }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            }
            
            return Disposables.create()
        }
    }
    
    fileprivate func searchParameters(user : String, count : Int) -> Parameters {
        return [
            "screen_name" : user,
            "count" : count
        ]
    }
    
    fileprivate func apiHeaders() -> HTTPHeaders {
        if let token = currentToken {
            return [
                "Authorization" : "Bearer \(token)"
            ]
        }else{
            return [:]
        }
        
    }
    
    fileprivate func headerCredentials() -> HTTPHeaders {
        let encodedCredentials = "\(Credentials.apiKey):\(Credentials.secret)".base64Encoding()
        return [
            "Authorization" : "Basic \(encodedCredentials)",
            "Content-Type" : "application/x-www-form-urlencoded;charset=UTF-8",
            ]
    }
    
    fileprivate func tokenParameters() -> Parameters {
        return ["grant_type" : "client_credentials"]
    }
}

extension String {
    func base64Encoding() -> String {
        if let data = data(using: .utf8) {
            return data.base64EncodedString()
        }
        return ""
    }
    
    func urlEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

