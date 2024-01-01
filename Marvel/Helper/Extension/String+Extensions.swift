//
//  String+Extensions.swift
//  Marvel
//
//  Created by Mohamed Osama on 29/12/2023.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        if let data = self.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { body -> String in
                if let baseAddress = body.baseAddress {
                    CC_MD5(baseAddress, CC_LONG(data.count), &digest)
                    return ""
                } else {
                    return ""
                }
            }
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
        return ""
    }
}

