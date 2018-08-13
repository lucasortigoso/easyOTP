//
//  OTPAlgorithm.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 12/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Foundation

public enum OTPAlgorithm {
    //Hash Algorithm to use, either SHA-1, SHA-256 or SHA-512
    case sha1
    case sha256
    case sha512
}
