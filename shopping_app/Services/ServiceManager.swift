//
//  ServiceManager.swift
//  shopping_app
//
//  Created by Evghenia Moroz on 10/15/20.
//

import Foundation
protocol ServiceManagerProtocol {
    func fetchData(params: RequestModel, completion: @escaping (Result<Products?, Error>) -> Void)
}


struct RequestModel {
    let query: String
    let page: Int
}

class ServiceManager: ServiceManagerProtocol {
    
    static let shared: ServiceManager = {
        return ServiceManager()
    }()
    public var isRunning: Bool = false
    
    private init() {}
    
    private var baseURL: URLComponents = URLComponents(string: "https://bdk0sta2n0.execute-api.eu-west-1.amazonaws.com/ios-assignment/search?")!
    
    private func load(url: URL, withCompletion completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            completion(data, error)
        })
        task.resume()
    }
    
    public func fetchData(params: RequestModel, completion: @escaping (Result<Products?, Error>) -> Void) {
        baseURL.query = "query=\(params.query)&page=\(params.page)"
        guard let url = baseURL.url else {
            return
        }
        isRunning = true
        load(url: url) { [weak self] data, error in
            self?.isRunning = false
            if let data = data {
                let products = try? JSONDecoder().decode(Products.self, from: data)
                completion(.success(products ?? nil))
            } else {
                completion(.failure(error!))
            }
        }
    }
}
