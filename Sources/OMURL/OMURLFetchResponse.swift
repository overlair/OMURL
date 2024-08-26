//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation
import SwiftSoup

public struct OMURLFetchResponse {
    public let data: Data?
    public let response: URLResponse?
    public let error: Error?
}


public extension OMURLFetchResponse {
    public func parse(parser: OMURLDocumentParser) throws -> OMURLMetadataResponse {
        guard let htmlResponse = response as? HTTPURLResponse,
              htmlResponse.ok else {
            throw OMURLError.fetchError
        }
        
        
        var encoding: String.Encoding = .utf8

        if var contentType = htmlResponse.allHeaderFields["Content-Type"] as? String {
            contentType = contentType.lowercased()
            let encodings = String.Encoding.allCases
            for e in encodings {
                if contentType.contains(e.displayName()) {
                    encoding = e
                }
            }
            
            if contentType.contains("iso-8859-1") {
                encoding = .windowsCP1250
            }
        }
        guard let data, let html = String(data: data, encoding: encoding) else {
            throw OMURLError.invalidResponse
        }
        
        let document = try SwiftSoup.parse(html)
        
        let parsed = try parser.parse(document: document)
        
        return parsed
    }
    
    public func parse(parsers: [OMURLDocumentParser]) throws -> OMURLMetadataResponse {
        guard let htmlResponse = response as? HTTPURLResponse,
              htmlResponse.ok else {
            throw OMURLError.fetchError
        }
        
        guard let data, let html = String(data: data, encoding: .utf8) else {
            throw OMURLError.invalidResponse
        }
        
        let document = try SwiftSoup.parse(html)
        var result: [String: [String]] = [:]

        for parser in parsers {
            let parsed = try parser.parse(document: document)
            result.merge(parsed.source) { a, b in
                return a + b
            }
        }
        return OMURLMetadataResponse(source: result)
    }
}
