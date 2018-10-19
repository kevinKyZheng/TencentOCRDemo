//
//  ViewController.swift
//  tencentOCR
//
//  Created by ios on 2018/10/19.
//  Copyright © 2018年 KY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //腾讯OCR相关
    let baseUrl = "https://api.ai.qq.com/fcgi-bin/ocr/ocr_bcocr"
    let appId = ""
    let appKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getParams(image:UIImage)->Dictionary<String, String>{
        
        let imageStr = self.getBase64ImageStringFromImage(image)
        let nowdate = Date()
        let timeInterval = nowdate.timeIntervalSince1970
        let timeStr = String(Int32(timeInterval))
        
        let dic:Dictionary<String,String> = [
            "app_id":appId,
            "time_stamp":timeStr,
            "nonce_str":"o1w5w2rov3",
            "image":imageStr ?? "",
            ]
        //获取sign
        let sign = self.getSign(dic: dic,appKey: appKey)
        
        let params:[String:String] = [
            "app_id":appId,
            "time_stamp":timeStr,
            "nonce_str":"o1w5w2rov3",
            "image":imageStr!,
            "sign":sign
        ]
        return params
    }
 
    func getSign(dic:Dictionary<String, String>,appKey:String)->String{
        let allKeys = dic.keys
        //升序排序 的 key
        let sortedKeys = allKeys.sorted { (str1, str2) -> Bool in
            return str1.localizedStandardCompare(str2) == .orderedAscending
        }
        //自定义字符集
        let custom = CharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted
        //        升序排序 的 Value
        let valueArr = sortedKeys.map { (item) -> String? in
            //将value进行url编码
            return dic[item]?.addingPercentEncoding(withAllowedCharacters: custom)
        }
        //        将key和value拼接起来
        var signArr = Array<String>()
        for index in 0 ..< sortedKeys.count {
            let keyValueStr = "\(sortedKeys[index])=\(valueArr[index]!)"
            signArr.append(keyValueStr)
        }
        
        let sign = signArr.joined(separator: "&") + "&app_key=\(appKey)"
        let upperSec = sign.uppercased()
        //此处要md5加密(代码中为实现,请自行实现)
//        let upperSec = sign.md5().uppercased()
        return upperSec
    }

    func getBase64ImageStringFromImage(_ image: UIImage) -> String? {
        guard var imageData = UIImageJPEGRepresentation(image, 1.0) else {
            
            return nil
        }
        var tImage = image
        
        while imageData.count > 500 * 1000 {
            imageData = UIImageJPEGRepresentation(tImage, 0.8)!
            tImage = UIImage(data: imageData)!
        }
        
        
        ///根据二进制编码得到对应的base64字符串
        let base64String = imageData.base64EncodedString()
        
        return base64String
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

