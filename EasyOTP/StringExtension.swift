//
//  StringExtension.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 12/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Foundation

extension String {
    /// Data never nil
    internal var dataUsingUTF8StringEncoding: Data {
        return utf8CString.withUnsafeBufferPointer {
            return Data(bytes: $0.dropLast().map { UInt8.init($0) })
        }
    }
    
    /// Array<UInt8>
    internal var arrayUsingUTF8StringEncoding: [UInt8] {
        return utf8CString.withUnsafeBufferPointer {
            return $0.dropLast().map { UInt8.init($0) }
        }
    }
}
