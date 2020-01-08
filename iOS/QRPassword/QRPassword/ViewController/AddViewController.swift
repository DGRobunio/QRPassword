//
//  AddViewController.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/13.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit

class AddViewController: UITableViewController {

    var selectedData:Passwd?
    
    @IBOutlet weak var websiteLabel: UITextField!
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwdLabel: UITextField!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
        
//        let test = PasswordData(id: 5, website: "asd32", url: "http://ssr.tool", username: "cyaaa", password: "sada")
        var newData:PasswordData?
        if urlLabel.text == "" || usernameLabel.text == "" || passwdLabel.text == "" {
            let alertController = UIAlertController(title: "请输入必要项!", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)            }
        } else {
            if selectedData == nil {
                if websiteLabel.text == "" {
                    newData = dataCollect(website: urlLabel.text!, url: urlLabel.text!, username: usernameLabel.text!, password: passwdLabel.text!)
                } else {
                    newData = dataCollect(website: websiteLabel.text!, url: urlLabel.text!, username: usernameLabel.text!, password: passwdLabel.text!)
                }
                if insert(PasswordData: newData!) {
                    print("""
                        New Data Information :
                        id:\(newData!.getId())
                        website:\(newData!.getWebsite())
                        url:\(newData!.getUrl())
                        username:\(newData!.getUsername())
                        """)
                    let alertController = UIAlertController(title: "保存成功!", message: nil, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                        self.dismiss(animated: true, completion: nil)}
                }
            } else {
                if websiteLabel.text == "" {
                    newData = dataCollect(id: selectedData!.id, website: urlLabel.text!, url: urlLabel.text!, username: usernameLabel.text!, password: passwdLabel.text!)
                } else {
                    newData = dataCollect(id: selectedData!.id, website: websiteLabel.text!, url: urlLabel.text!, username: usernameLabel.text!, password: passwdLabel.text!)
                }
                if update(PasswordData: newData!) {
                    print("""
                        Data Updated Information :
                        id:\(newData!.getId())
                        website:\(newData!.getWebsite())
                        url:\(newData!.getUrl())
                        username:\(newData!.getUsername())
                        """)
                    let alertController = UIAlertController(title: "保存成功!", message: nil, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                        self.dismiss(animated: true, completion: nil)}
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedData != nil {
            preLoadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    func dataCollect(website: String, url: String, username: String, password: String) -> PasswordData {
        let dataCell = PasswordData(id: nextId(), website: website, url: url, username: username, password: password)
        return dataCell
    }
    
    func dataCollect(id: Int64, website: String, url: String, username: String, password: String) -> PasswordData {
        let dataCell = PasswordData(id: id, website: website, url: url, username: username, password: password)
        return dataCell
    }
    
    
    func preLoadData() {
        let data = self.selectedData!
        websiteLabel.text = data.website
        urlLabel.text = data.url
        usernameLabel.text = data.username
        passwdLabel.text = data.password
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
