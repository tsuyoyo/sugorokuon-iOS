//
//  ProgramDescriptionViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/24.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import SafariServices

class ProgramDescriptionViewController: UIViewController {
    
    private let fontStyle =
        "<head><style>" +
            "body { " +
            "  font-size: 12pt;" +
            "  font-family: sans-serif;" +
            "}" +
            "</style></head>"

    private var program : Program?
    private var descriptionData : String?
    
    // To handle links on description/info content
    fileprivate var firstDataLoading = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
        if let title = program?.title {
            label?.text = title
        }
        
        if let webView = webView, let program = program {
            var descriptionData = "<!DOCTYPE html><html>\(fontStyle)<body>"

            if let d = program.description {
                descriptionData += d + "<BR><BR><BR>"
            }
            if let i = program.info {
                descriptionData += i
            }
            descriptionData += "</body></html>"
            
            webView.loadHTMLString(descriptionData, baseURL: nil)
            
            firstDataLoading = true
            webView.delegate = self
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func set(program: Program) {
        self.program = program
    }
    
    @IBAction func onClosed(_ sender: Any) {
        dismiss(animated: true, completion: { () -> Void in
            print("closed")
        })
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

extension ProgramDescriptionViewController : UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if firstDataLoading {
            return true
        }
        
        if let url = request.url {
            
            // メモ : twitter の scheme は http
//            print("scheme - \(url.scheme)")
            
            if url.scheme! == "mailto" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
            return false
        } else {
            return true
        }
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        firstDataLoading = false
    }

}
