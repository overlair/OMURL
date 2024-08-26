//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation


public protocol OMURLFetchable {
    typealias CompletionHandler = @Sendable (OMURLFetchResponse) -> Void

    func dataTask(with url: URL,
                  completionHandler: @escaping CompletionHandler)
    
    func dataTask(with urlRequest: URLRequest,
                  completionHandler: @escaping CompletionHandler)
}
