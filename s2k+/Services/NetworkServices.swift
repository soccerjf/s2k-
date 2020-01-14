
//
//  NetworkServices.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-10.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkServices: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkServices {
    
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                //TODO: capture error and react
                print("Error in guard data")
                return
            }

            completion(self?.decode(data))
        })
        task.resume()
    }
}

class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ImageRequest: NetworkServices {
    func decode(_ data: Data) -> UIImage? {

        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: completion)
    }
}

class APIRequest<Resource: APIResource> {
    let resource: Resource
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkServices {
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let wrapper = try? JSONDecoder().decode(Wrapper<Resource.ModelType>.self, from: data)
        return wrapper?.items
    }
    
    func load(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}

protocol APIResource {
    associatedtype ModelType: Decodable
    var queryItems: [URLQueryItem] { get }

}

extension APIResource {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sandbox.8thline.org"
        components.path = "/s2kAPIData.php"
        components.queryItems = queryItems
        return components.url!
    }
}

struct LeagueResource: APIResource {
    typealias ModelType = League
    var queryItems : [URLQueryItem]
}

struct TeamResource: APIResource {
    typealias ModelType = Team
    var queryItems : [URLQueryItem]
}

