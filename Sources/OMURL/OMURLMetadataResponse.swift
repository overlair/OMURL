//
//  File.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation

public struct OMURLMetadataResponse {
    let source: [String: [String]]
}

public extension OMURLMetadataResponse {
    /// The title of the OpenGraph content.
    var title: String? {
        source.stringValue("og:title") ?? source.stringValue("title")
    }
    
    var images: URL? {
        source.urlValue("images")
    }
    
    var icon: String? {
        source.stringValue("icon")
    }
    
    /// The type of the OpenGraph content.
    var type: String? {
        source.stringValue("og:type")
    }
    
    /// The description of the OpenGraph content.
    var description: String? {
        source.stringValue("og:description")
    }
    
    /// The URL of the OpenGraph content.
    var url: URL? {
        source.urlValue("og:url")
    }
   
    
    /// The alt text of the main image associated with the OpenGraph content.
    var imageAlt: String? {
        source.stringValue("og:image:alt")
    }
    
    /// The secure URL of the main image associated with the OpenGraph content.
    var imageSecureURL: URL? {
        source.urlValue("og:image:secure_url")
    }
    
    /// The MIME type of the main image associated with the OpenGraph content.
    var imageType: String? {
        source.stringValue("og:image:type")
    }
    
    /// The width of the main image associated with the OpenGraph content.
    var imageWidth: Double? {
        source.doubleValue("og:image:width")
    }
    
    /// The height of the main image associated with the OpenGraph content.
    var imageHeight: Double? {
        source.doubleValue("og:image:height")
    }
    
    /// The site name associated with the OpenGraph content.
    var siteName: String? {
        source.stringValue("og:site_name")
    }
    
    /// The list of allowed countries for accessing the OpenGraph content.
    var restrictionsCountriesAllowed: [String]? {
        source["og:restrictions:country:allowed"]
    }
    
    /// The URL of the audio associated with the OpenGraph content.
    var audioURL: URL? {
        source.urlValue("og:audio")
    }
    
    /// The determiner of the OpenGraph content.
    var determiner: String? {
        source.stringValue("og:determiner")
    }
    
    /// The locale of the OpenGraph content.
    var locale: String? {
        source.stringValue("og:locale")
    }
    
    /// The list of alternate locales for the OpenGraph content.
    var localeAlternate: [String]? {
        source["og:locale:alternate"]
    }
    
    /// The URL of the video associated with the OpenGraph content.
    var videoURL: URL? {
        source.urlValue("og:video")
    }
    
    
   
    var ogImageURL: URL? {
        source.urlValueWithoutSVG("og:image")
    }
      
    var iconURL: URL? {
        source.urlValueWithoutSVG("icon")
    }
      
    var imageURL: URL? {
        source.urlValueWithoutSVG("images")
    }
    
    var twitterTileImage: URL? {
        source.urlValueWithoutSVG("twitter:image")
    }

    var appleImage: URL? {
//        source.urlValueWithoutSVG("apple-touch-icon-precomposed") ??
        source.urlValueWithoutSVG("apple-touch-icon")
    }
        

    var msApplicationTileImage: URL? {
        source.urlValueWithoutSVG("msapplication-TileImage")
    }
    
    var faviconImage: URL? {
        guard let url, let host = url.host else { return nil}
        var favicon = (url.scheme ?? "https") + "://" + host + "/favicon.ico"
        
        return URL(string: favicon)
    }
   
    
    var representativeURL: URL? {
        if let url,  url.absoluteString.contains("youtube.com/watch") {
            
            if let videoId = url.query?.dropFirst(2) {
                let url = "http://img.youtube.com/vi/\(videoId)/0.jpg"
                return URL(string: url)
            }
        }
        else if  let url, let host = url.host, host.contains("tiktok.com") {
            return URL(string:"https://www.tiktok.com/favicon.ico")
        } else  if  let url, let host = url.host, host.contains("google.com") {
            return URL(string:"https://www.google.com/favicon.ico")
        }
        else  if let url  {
            let possibleImages: [URL] = [msApplicationTileImage, appleImage, twitterTileImage, ogImageURL,   iconURL, imageURL, faviconImage].compactMap { $0 }
//            let filteredImages = possibleImages.filter { url in
//                guard let url else { return false }
//                return !url.absoluteString.contains(".svg")
//            }
            
            if let imageURL = possibleImages.first {
                let scheme = imageURL.scheme ?? "https"
                if scheme == "data" {
                    return nil
                }
                
//                print("BUILDER", imageURL, url)
                let host = imageURL.host ?? ((url.host ?? "") + url.path )

             
                var path = imageURL.path
                
                path = path.replacingOccurrences(of: "//", with: "/")
                if path.first != "/" && host.last != "/" {
                    path = "/" + path
                } else if path.first == "/" && host.last == "/" {
                    path = String(path.dropFirst())
                }
                
                var query = imageURL.query ?? ""
                if !query.isEmpty  {
                    query = "?" + query
                }
                
                let text = scheme + "://" + host + path + query// components //+ query
                
                return URL(string: text)
            }
        }
        
        return nil
    }
    
}

public extension OMURLMetadataResponse {
    /// Retrieves an array of values associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the array of values.
    /// - Returns: An array of values associated with the key, if present; otherwise, `nil`.
    func arrayValue(_ key: String) -> [String]? {
        source[key]
    }
    
    /// Retrieves a string value associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the string value.
    /// - Returns: A string value associated with the key, if present; otherwise, `nil`.
    func stringValue(_ key: String) -> String? {
        source.stringValue(key)
    }
    
    /// Retrieves a double value associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the double value.
    /// - Returns: A double value associated with the key, if present; otherwise, `nil`.
    func doubleValue(_ key: String) -> Double? {
        source.doubleValue(key)
    }
    
    /// Retrieves a URL value associated with the specified key from the source.
    /// - Parameter key: The key for which to retrieve the URL value.
    /// - Returns: A URL value associated with the key, if present; otherwise, `nil`.
    func urlValue(_ key: String) -> URL? {
        source.urlValue(key)
    }
}


private extension Dictionary where Element == (key: String, value: [String]) {
    func stringValue(_ key: String) -> String? {
        self[key]?.first(where: { i in
            !i.isEmpty
        })
    }
    
    func doubleValue(_ key: String) -> Double? {
        guard let doubleValue = self[key]?.first(where: { i in
            !i.isEmpty
        }) else {
            return nil
        }
        return Double(doubleValue)
    }
    
    func urlValue(_ key: String) -> URL? {
        guard let string = self[key]?.first(where: { i in
            !i.isEmpty
        }) else {
            return nil
        }
        return URL(string: string)
    }
    
    func urlValueWithoutSVG(_ key: String) -> URL? {
        guard let string = self[key]?.first(where: { i in
            !i.isEmpty && !i.contains(".svg")
        }) else {
            return nil
        }
        
        return URL(string: string)
    }
}
