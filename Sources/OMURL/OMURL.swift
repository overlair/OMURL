// The Swift Programming Language
// https://docs.swift.org/swift-book

import WebKit
import SwiftSoup
import Foundation


public class OMURLManager: NSObject, URLSessionDelegate {
        public typealias CompletionHandler = @Sendable (OMURLFetchResponse) -> Void
    
    public func fetch(_ url: URL, completion: @escaping CompletionHandler) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        fetch(request, completion: completion)
    }
    
    public func fetch(_ urlRequest: URLRequest, completion: @escaping CompletionHandler) {
        guard let url = urlRequest.url else { return  }
        if handlers.keys.contains(url) {
            handlers[url]?.append(completion)
        } else {
            handlers[url] = [completion]
            dataTask(with: urlRequest, completionHandler: completion)
        }
        
    }
    
//    public func put() {}
    
    public func cancel(url: URL) {
        tasks[url]?.cancel()
    }
    
    public func cancel(urlRequest: URLRequest) {
        guard let url = urlRequest.url else { return  }
        cancel(url: url)
    }
    
    
    
    lazy private var session: URLSession = {
        let config = URLSessionConfiguration.default
        
        let agent = (WKWebView().value(forKey: "userAgent") as? String) ?? ""
        config.httpAdditionalHeaders = ["User-Agent": agent]

       let session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        return session
    }()
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 64
        return queue
    }()
    
    private var handlers = [URL: [CompletionHandler]]()
    private var tasks = [URL: URLSessionDataTask]()

    
    
    
    
    private func dataTask(with urlRequest: URLRequest, completionHandler: @escaping CompletionHandler){
       
            let task = session.dataTask(with: urlRequest, completionHandler: { [weak self]
                data, response, error in

                let result = OMURLFetchResponse(data: data, response: response, error: error)
                guard let url = urlRequest.url,  let completionHandlers = self?.handlers[url] else { return }

                for handler in completionHandlers {
                    handler(result)
                }
                    
                DispatchQueue.main.async {
                    self?.handlers.removeValue(forKey: url)
                    self?.tasks.removeValue(forKey: url)
                }
            })
        
        queue.addOperation {
            task.resume()
        }
        
    }
    

    
    
    
    public func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
//        queue.addOperation {
            completionHandler(request)
//        }
    }
}



class X {
    func y() {
        let manager = OMURLManager()
        manager.fetch(.init(string: "")!) { response in
            do {
                let parser = OMURLDocumentOpenGraphParser()
                let parsed = try response.parse(parser: parser)
            } catch {
                
            }
        }
    }
}

