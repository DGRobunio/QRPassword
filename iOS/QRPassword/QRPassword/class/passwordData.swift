//
//  passwordData.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/13.
//  Copyright © 2019 demo. All rights reserved.
//

import Foundation

public class PasswordData {
    private var id : Int64 = 0
    private var website : String = ""
    private var url : String = ""
    private var username : String = ""
    private var password : String = ""

    
    init(id: Int64, website: String, url: String, username: String, password: String) {
        self.id = id
        self.website = website
        self.url = url
        self.username = username
        self.password = password
    }
    
    public func getId() -> Int64 {
        return id
    }
    
    public func getWebsite() -> String {
        return website
    }
    
    public func getUrl() -> String {
        return url
    }
    
    public func getUsername() -> String {
        return username
    }
    
    public func getPassword() -> String {
        return password
    }
}
