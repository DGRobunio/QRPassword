//
//  AboutViewController.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/13.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "about", ofType: "html")
        let urlStr = URL.init(fileURLWithPath: path!)
        webView.loadRequest(URLRequest(url: urlStr))
        // Do any additional setup after loading the view.
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
