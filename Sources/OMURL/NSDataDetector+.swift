//
//  File.swift
//  
//
//  Created by John Knowles on 7/13/24.
//

import Foundation

extension String {
    func links() throws -> [URL] {
        
        let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let matches = detector.matches(in: self,
                                       options: [],
                                       range: NSRange(location: 0, length: self.utf16.count))
        var urls: [URL] = []
        for match in matches {
            guard let range = Range(match.range, in: self)
            else { continue }
            
            let text =  self[range]
            
            // do the following?????
            let hasHTTP = !text.contains("http")
            let httpText = hasHTTP ? "https://" : ""
            let hasWWW = !text.contains("www.")
            let wwwText = hasWWW ? "www." : ""

            var urlString  = httpText +  text
            if  let url = URL(string: urlString) {
                urls.append(url)
            }
        }
        
        return urls
    }
    
}
