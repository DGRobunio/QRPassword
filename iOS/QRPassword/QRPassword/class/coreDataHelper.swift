//
//  coreDataHelper.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/14.
//  Copyright © 2019 demo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let serverUrl:URL = URL(string: "http://172.20.10.3:3000/")!
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

func fetch() -> [Passwd]? {
    let fetchRequest = NSFetchRequest<Passwd>(entityName: "Passwd")
    var info : [Passwd]?
    do {
        info = try context.fetch(fetchRequest)
    } catch {
        print(error)
    }
    return info
}

func insert(PasswordData pData: PasswordData) -> Bool {
    let info = Passwd(context: context)
    info.id = pData.getId()
    info.website = pData.getWebsite()
    info.url = pData.getUrl()
    info.username = pData.getUsername()
    info.password = pData.getPassword()
    do {
        try context.save()
        return true
    } catch {
        print(error)
        return false
    }
}

func delete(Info info: [Passwd], index: IndexPath) -> Bool {
    context.delete(info[index.row])
    
    do {
        try context.save()
        return true
    } catch {
        return false
    }
}

func update(PasswordData pData: PasswordData) -> Bool {
    let fetchRequest = NSFetchRequest<Passwd>(entityName: "Passwd")
//    fetchRequest.predicate = NSPredicate(format: "id = %@", pData.getId())
    do {
        let info = try context.fetch(fetchRequest) as [Passwd]
        for infoData in info {
            if infoData.id == pData.getId() {
                let updatedInfo = infoData
                updatedInfo.website = pData.getWebsite()
                updatedInfo.url = pData.getUrl()
                updatedInfo.username = pData.getUsername()
                updatedInfo.password = pData.getPassword()
                try context.save()
                break
            }
        }
        return true
    } catch {
        print(error)
        return false
    }
}

func nextId() -> Int64 {
    let fetchRequest = NSFetchRequest<Passwd>(entityName: "Passwd")
    do {
        var nextNum: Int64 = 0
        let info = try context.fetch(fetchRequest)
        for currentInfo in info {
            if currentInfo.id > nextNum {
                nextNum = currentInfo.id
            }
        }
        return nextNum+1
    } catch {
        return 0
    }

}
