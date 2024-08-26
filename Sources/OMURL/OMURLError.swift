//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation


/// Represents errors that can occur during OpenGraph operations.
public enum OMURLError: Error {
    case invalidURL
    case fetchError
    case invalidResponse
    case parsingError(Error)
}

