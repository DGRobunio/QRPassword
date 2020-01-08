//
//  crypto.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/13.
//  Copyright © 2019 demo. All rights reserved.
//

import Foundation
import CryptoSwift

public  class CodeContent {
    private var sessionID : String = ""
    private var secretKey : String = ""
    private var hostname : String = ""
    
    init(sessionID : String, secretKey : String, hostname : String) {
        self.sessionID = String(Int(sessionID, radix: 16)!)
        self.secretKey = String(Int(secretKey, radix: 16)!)
        self.hostname = String(data: Data(base64Encoded: hostname)!, encoding: .utf8)!
    }
    
    public func getSessionID() -> String {
        return sessionID
    }
    
    public func getSecretKey() -> String {
        return secretKey
    }
    
    public func getHostname() -> String {
        return hostname
    }
}
func encrypt(secretKey: String, initVector: String, plain: String) -> String {
    do {
        let aes = try AES(key: secretKey.bytes , blockMode: CBC(iv: initVector.bytes ) , padding: .pkcs5)
        let encrypted = try aes.encrypt(plain.bytes)
        return encrypted.toBase64()!
    } catch  {
        print(error)
    }
    return ""
}
func decrypt(secretKey: String, initVector: String, encrypted: String) -> String {
    do {
        let aes = try AES(key: secretKey.bytes , blockMode: CBC(iv: initVector.bytes ) , padding: .pkcs5)
        let decrypted = try encrypted.decryptBase64ToString(cipher: aes)
        return decrypted
    } catch  {
        print(error)
    }
    return ""
}
func parse (encoded: String) -> CodeContent {
    let buf1 = encoded.index(encoded.startIndex, offsetBy:7)
    let buf2 = encoded.index(encoded.startIndex, offsetBy: 21)
    return CodeContent(sessionID: String(encoded.prefix(upTo: buf1)), secretKey: String(encoded[buf1..<buf2]), hostname: String(encoded.suffix(from: buf2)))
}
