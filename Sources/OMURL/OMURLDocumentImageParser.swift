//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation


public struct OMURLDocumentImageParser: OMURLDocumentParser{
    public init() {}

    public func parse(document: OMURLDocument) throws -> OMURLMetadataResponse {
        
        var result: [String: [String]] = [:]

        let images = try document.select("img")
        images.forEach { image in
            guard let source = try? image.attr("src") else { return }
            
            var currentValues = result["images", default: []]
            currentValues.append(source)
            result.updateValue(currentValues, forKey: "images")
        }
        
        return OMURLMetadataResponse(source: result)
    }
}
