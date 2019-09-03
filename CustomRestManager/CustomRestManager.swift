//
//  CustomRestManager.swift
//  CustomRestManager
//
//  Created by Tariq Najib on 31/08/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation

public class CustomRestManager {
   public var httpBody: Data?
   public var task: URLSessionTask?
   public var requestHeaders = APIEntity()
   public var urlQueryParameters = APIEntity()
   public var httpBodyParameters = APIEntity()
   public var ctCache = CTCache.shared
   public let session = URLSession(configuration: .default)
   public static let shared = CustomRestManager()
    
   public typealias completion = (_ result: Results) -> Void
   public var tasks = [URL: [completion]]()
    public init(){}
    fileprivate func addQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
                var queryItems = [URLQueryItem]()
                for (key, value) in urlQueryParameters.allValues() {
                    let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                    queryItems.append(item)
                }
                urlComponents.queryItems = queryItems
                guard let updatedURL = urlComponents.url else { return url }
                return updatedURL
            } else { return url }
        }
        return url
    }
    fileprivate func getHttpBody() -> Data? {
        guard let contentType = requestHeaders.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    fileprivate func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpsMethods) -> URLRequest? {
        if let url = url {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
            request.httpBody = httpBody
            request.httpMethod = httpMethod.rawValue
            for (header, value) in requestHeaders.allValues() {
                request.setValue(value, forHTTPHeaderField: header)
            }
            return request
        } else { return nil }
    }
    
    public func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.task = self.session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            self.task?.resume()
        }
    }
    
    public func makeRequest(toURL url: URL,
                            withHttpMethod httpMethod: HttpsMethods,
                            completion: @escaping (completion)) {
        session.dataTask(with: url).cancel()
        if tasks.keys.contains(url) {
            tasks[url]?.append(completion)
        } else {
            self.tasks[url] = [completion]
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let targetURL = self?.addQueryParameters(toURL: url)
                let httpBody = self?.getHttpBody()
                guard let request = self?.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
                    completion(Results(withError: ServiceErrors.requestFailed))
                    return
                }
                
                
                let _ = self?.session.dataTask(with: request, completionHandler:  { [weak self] (data, response, error) in
                    
                    guard let completionHandlers = self?.tasks[url] else { return }
                    for handler in completionHandlers {
                        if let data = data {
                            self?.ctCache.memoryCache.setCacheObjForKey(cacheKey: NSString(string: url.absoluteString), value: NSData(data: data))
                        }
                        
                        handler(Results(withData: data,
                          response: Response(urlResponse: response),
                          error: error))
                    }
                }).resume()
            }
        }
        
    }
}
public extension CustomRestManager {
    enum HttpsMethods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    enum ServiceErrors: LocalizedError {
        case noInternetConnection
        case custom(String)
        case requestFailed
    }
}
public extension CustomRestManager.ServiceErrors {
    var localizedDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .requestFailed:
            return "Failed to create request"
        case .custom(let message):
            return message
        }
    }
}
