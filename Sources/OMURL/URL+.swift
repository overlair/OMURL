//
//  File.swift
//  
//
//  Created by John Knowles on 7/13/24.
//

import Foundation


extension URL {
    /** Request the http status of the URL resource by sending a "HEAD" request over the network. A nil response means an error occurred. */
    public func requestHTTPStatus(completion: @escaping (_ status: Int?) -> Void) {
        // Adapted from https://stackoverflow.com/a/35720670/7488171
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, error == nil {
                completion(httpResponse.statusCode)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    /** Measure the response time in seconds of an http "HEAD" request to the URL resource. A nil response means an error occurred. */
    public func responseTime(completion: @escaping (TimeInterval?) -> Void) {
        let startTime = DispatchTime.now().uptimeNanoseconds
        requestHTTPStatus { (status) in
            if status != nil {
                let elapsedNanoseconds = DispatchTime.now().uptimeNanoseconds - startTime
                completion(TimeInterval(elapsedNanoseconds)/1e9)
            }
            else {
                completion(nil)
            }
        }
    }
}

public extension URL {
    public func wwwLessHost() -> String? {
        guard var host else { return nil }
        if host.starts(with: "www.", by: { a, b in
            a == b
        }) {
            host = String(host.dropFirst(4))
        }
        return host
    }
}


extension URL {
    func string() -> String {
        ""
//        let hasHTTP = !text.contains("http")
//        let httpText = hasHTTP ? "https://" : ""
//        let hasWWW = !text.contains("www.")
//        let wwwText = hasWWW ? "www." : ""
        
    }
    
}


extension HTTPURLResponse {
    var ok: Bool {
        (200...299).contains(statusCode)
    }
}
