//
//  ScanViewController.swift
//  QRPassword
//
//  Created by 张伊凡 on 2019/3/15.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var centView: UIView!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCaptureDevice()
        self .customUI()
    }
    func customUI() {
        centView.layer.borderColor = UIColor.red.cgColor
        centView.layer.borderWidth = 1
        self.view.bringSubviewToFront(centView)
    }
    func addCaptureDevice()  {
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            //初始化媒体捕捉的输入流
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            //初始化AVcaptureSession
            captureSession = AVCaptureSession()
            //设置输入到Session
            captureSession?.addInput(input)
        }  catch  {
            // 捕获到移除就退出
            print(error)
            return
        }
        
        let Output = AVCaptureMetadataOutput()
        captureSession?.addOutput(Output)
        
        //设置代理 扫描的目标设置为二维码
        Output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        Output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        
        // 取出第一个对象
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                print(metadataObj.stringValue!)
                matchAndSendInfo(qrString: metadataObj.stringValue!)
//                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func matchAndSendInfo(qrString qrstr: String) {
        //Data in QR Code
        let context:CodeContent = parse(encoded: qrstr)
        let sessionId = context.getSessionID()
        print(sessionId)
        let secrectKey = context.getSecretKey()
        print(secrectKey)
        let initVector = "0000000000000000"
        let hostname = context.getHostname()
        print(hostname)
        var password, username:String?
        //CoreData
        let info = fetch()
        //Judge
        var found: Bool = false
        
        if info != nil {
            for infoCell in info! {
//                print(infoCell.url)
                if infoCell.url == hostname {
                    found = true
                    username = infoCell.username
                    password = infoCell.password
                    
//                    sessionId = sessionId.replacingOccurrences(of: "\r", with: "")
//                    sessionId = sessionId.replacingOccurrences(of: "\n", with: "")
                    let json = ["id": sessionId,
                                "hostname": encrypt(secretKey: secrectKey, initVector: initVector, plain: hostname),
                                "username": encrypt(secretKey: secrectKey, initVector: initVector, plain: username!),
                                "password": encrypt(secretKey: secrectKey, initVector: initVector, plain: password!)]
//                    let testData = decrypt(secretKey: secrectKey, initVector: initVector, encrypted: json["hostname"].stringValue)
//                    print("decrypted:\(testData)")
                    if sendRequest(jsonString: json) {
                        let alertController = UIAlertController(title: "识别成功!正在发送。。。", message: nil, preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.presentedViewController?.dismiss(animated: false, completion: nil)
                            self.dismiss(animated: true, completion: nil)}
                    }
                    break
                }
            }
            if !found {
                let alertController = UIAlertController(title: "找不到对应账户!", message: nil, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                    self.dismiss(animated: true, completion: nil)}
            }
        } else {
            let alertController = UIAlertController(title: "数据库为空!", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: nil)}
        }
        
    }
    
    func sendRequest(jsonString json:[String:String]) -> Bool {
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: serverUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "charset")
        request.httpMethod = "POST"
        do {
//            let postString = json.compactMap({ (key, value) -> String in
//                return "\(key)=\(value)"
//            }).joined(separator: "&")
//            request.httpBody = postString.data(using: .utf8)
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch {
            print(error)
        }
        print(request.url!)
        let task:URLSessionTask = session.dataTask(with: request) {(data, response, error) in
//            do {
                print("receiving...")
//                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                print(r)
//            } catch {
//                print(error)
//            }
        }
        task.resume()
        return true
//        return false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    */

}
