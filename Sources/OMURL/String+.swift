//
//  File 2.swift
//  
//
//  Created by John Knowles on 7/17/24.
//

import Foundation


extension String.Encoding: CaseIterable {
    public static var allCases: [String.Encoding] {
        [
        .ascii,
        .nextstep,
        .japaneseEUC,
        .utf8,
        .isoLatin1,
        .symbol,
        .nonLossyASCII,
        .shiftJIS,
        .isoLatin2,
        .unicode,
        .windowsCP1251,
        .windowsCP1252,
        .windowsCP1253,
        .windowsCP1254,
        .windowsCP1250,
        .iso2022JP,
        .macOSRoman,
        .utf16,
        .utf16BigEndian,
        .utf16LittleEndian,
        .utf32,
        .utf32BigEndian,
        .utf32LittleEndian
        ]
    }
}


