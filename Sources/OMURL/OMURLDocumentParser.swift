//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation

public protocol OMURLDocumentParser {
    func parse(document: OMURLDocument) throws -> OMURLMetadataResponse
}
