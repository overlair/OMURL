//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation

public struct OMURLDocumentLinkParser: OMURLDocumentParser{
    public init() {}

    public func parse(document: OMURLDocument) throws -> OMURLMetadataResponse {
        
        var result: [String: [String]] = [:]

        let links = try document.select("link")
        let _alinks = try document.select("a")
       
        return OMURLMetadataResponse(source: result)
    }
}
