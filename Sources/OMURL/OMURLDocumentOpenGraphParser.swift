//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation



public struct OMURLDocumentOpenGraphParser: OMURLDocumentParser{
    public init() {}
    public func parse(document: OMURLDocument) throws -> OMURLMetadataResponse {
        
        var result: [String: [String]] = [:]

        let metas = try document.select("meta")
        
        try metas.forEach { meta in
            var propertyName = try meta.attr("property")
            let content = try meta.attr("content")
            let metaName = try meta.attr("name")
            
            if propertyName.isEmpty {
                propertyName = metaName
            }
            
            var currentValues = result[propertyName, default: []]
            currentValues.append(content)
            result.updateValue(currentValues, forKey: propertyName)
        }
        
        if let title = try? document.title() {
            result["title"] = [title]
        }
        
        return OMURLMetadataResponse(source: result)
    }
}
