//
//  MainViewController.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/13.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var info : [Passwd]?
    var selectedData:Passwd?
    
    @IBOutlet weak var table: UITableView!
    @IBAction func qrScan(_ sender: UIBarButtonItem) {
//        let msg = UIAlertController(title: "噔 噔 咚", message: "没做完，急🔨?", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "nmd,wsm", style: .default, handler:nil)
//        msg.addAction(okAction)
//        self.present(msg,animated: true, completion: nil)
        
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanViewController")as!ScanViewController
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = info![indexPath.row].website
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell!.isSelected {
            self.selectedData = info![indexPath.row]
            print(self.selectedData)
        }
        performSegue(withIdentifier: "goToEditView", sender: cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        info = fetch()
//        var info : [Passwd] = []
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//
//        let tab = Passwd(context: context)
//        tab.id = 2
//        tab.website = "xcwv.cn"
//        tab.url = "xcv.eqwcn"
//        tab.username = "cyqwdkan"
//        tab.password = "Blyzdx4t"
//
//        do {
//            try context.save()
//            print("data Saved.")
//        }catch {
//            print(error)
//        }
//        let fetchRequest = NSFetchRequest<Passwd>(entityName: "Passwd")
//        fetchRequest.returnsObjectsAsFaults = false
//        do {
//            info = try context.fetch(fetchRequest)
//            if info.count != 0 {
//                for row in info {
//                    print(row)
//                }
//            }
//        }catch{
//            print(error)
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "DEL") { (rowAction, indexPath) in
            QRPassword.delete(Info: self.info!, index: indexPath)
            self.info = fetch()
            self.table.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        info = fetch()
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditView" {
            let midViewController = segue.destination as! UINavigationController
            let destinationViewController = midViewController.topViewController as! AddViewController
            destinationViewController.selectedData = self.selectedData
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
