//
//  databaseHelper.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/14.
//  Copyright © 2019 demo. All rights reserved.
//



/*
Coredata is used instead of SQLite
 */

import Foundation
import SQLite

//let serverUrl:URL = URL(string: "http://172.20.10.3:3000/")!

class DatabaseHelper {
    private let id = Expression<Int64>("id")
    private let website = Expression<String>("website")
    private let url = Expression<String>("url")
    private let username = Expression<String>("username")
    private let password = Expression<String>("password")
    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    public func databaseInit() -> Connection? {
        do{
            let db = try Connection("\(path)/QRPass.sqlite3")
            return db
        } catch {
            return nil
        }
    }
    
    public func loadTable(database db: Connection) -> Table {
        let table = Table("passwd")
        do {
            try db.run(table.create(ifNotExists: true) { cell in
                cell.column(id, primaryKey: .autoincrement)
                cell.column(website)
                cell.column(url)
                cell.column(username)
                cell.column(password)
            })
        }catch{
            print(error)
        }
        return table
    }

    public func insert(database db: Connection, table tab: Table, passwordData passwdData: PasswordData) -> Bool {
        do {
            try db.run(tab.insert( id <- Int64(passwdData.getId()),
                                     website <- passwdData.getWebsite(),
                                     url <- passwdData.getUrl(),
                                     username <- passwdData.getUsername(),
                                     password <- passwdData.getPassword()))
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    public func selectAll(database db: Connection, table tab: Table) -> [Row]?{
        let query = tab.select(id, website)
        do {
            let info = Array( try db.prepare(query))
            return info
        } catch  {
            return nil
        }
    }
    
    public func select(database db: Connection, table tab: Table, id: Int64) -> Row? {
        let query  = tab.filter(self.id == id)
        do {
            let info = try db.pluck(query)
            return info
        }catch {
            return nil
        }
    }
    
    public func delete (database db: Connection, table tab: Table, id: Int64) -> Bool {
        let query = tab.filter(self.id == id)
        do {
            try db.run(query.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    public func update(database db: Connection, table tab: Table, passwordData passwdData: PasswordData) -> Bool {
        let query = tab.filter(self.id == id)
        do {
             if try db.run(query.update( id <- Int64(passwdData.getId()),
                                         website <- passwdData.getWebsite(),
                                         url <- passwdData.getUrl(),
                                         username <- passwdData.getUsername(),
                                         password <- passwdData.getPassword())) > 0 {
                return true
            } else {
                return false
            }
        }catch {
            return false
        }
    }

}
