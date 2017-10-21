//
//  ProgramDescriptionViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/24.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import SafariServices
import GoogleMobileAds

class ProgramDescriptionViewController: UIViewController {
    
    @IBOutlet weak var admobBanner: GADBannerView!
    
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
    @IBOutlet weak var webSiteButton: UIButton!
    
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
        
        setupAdMob()
        
        if (program?.url != nil && (program?.url!.isEmpty)!)
            || program?.url == nil {
            webSiteButton.isEnabled = false
            webSiteButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        }
    }
    
    private func setupAdMob() {
        admobBanner.adUnitID = ADMOB_PUB_ID
        admobBanner.rootViewController = self
        // Simulator でのテスト。うまいやり方があるはず。
        let gadRequest = GADRequest()
        gadRequest.testDevices = [kGADSimulatorID]
        admobBanner.load(gadRequest)
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
    
    @IBAction func onWebSiteSelected(_ sender: Any) {
        if let webSite = program?.url {
            let safariViewController = SFSafariViewController(url: URL(string: webSite)!)
            present(safariViewController, animated: true, completion: nil)
        }
    }    
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
