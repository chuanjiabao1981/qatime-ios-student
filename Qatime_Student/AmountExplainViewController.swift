//
//  AmountExplainViewController.swift
//  Qatime_Student
//
//  Created by Shin on 2017/6/26.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit


let ScrenScale = UIScreen.main.bounds.size.width/414.0



class AmountExplainViewController: UIViewController ,UIWebViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏
        var _navigationBar : NavigationBar!
        
        //直接用webview加载富文本
        var _mainView : UIWebView!
        
        
        //主要
        self.view.backgroundColor = UIColor.white
        
        //加载导航栏
        _navigationBar = NavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.width_sd, height: 64))
        _navigationBar.titleLabel.text = "说明"
        self.view.addSubview(_navigationBar)
        _navigationBar.leftButton .setImage(UIImage.init(named: "back_arrow"), for: .normal)
        _navigationBar.leftButton.addTarget(self, action: #selector(returnLastPage), for: .touchUpInside)
        
        
        //主视图
        _mainView = UIWebView()
        _mainView.backgroundColor = UIColor.clear
        self.view .addSubview(_mainView)
        _mainView.sd_layout()
        .leftSpaceToView(self.view,0)?
        .rightSpaceToView(self.view,0)?
        .topSpaceToView(_navigationBar,0)?
        .bottomSpaceToView(self.view,0)
        
        //读取本地html
        let path = Bundle.main.path(forResource: "explain", ofType: "html")!
        let data = NSData.init(contentsOfFile: path)
        _mainView.load(data! as Data, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: NSURL.fileURL(withPath: Bundle.main.bundlePath))
        
        _mainView.delegate = self
        
    }
    
    //delegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        self.hudStart(withTitle: nil)
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hudStop(withTitle: nil)
    }
    
    
    func returnLastPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
