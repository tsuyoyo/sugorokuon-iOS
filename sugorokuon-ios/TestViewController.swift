//
//  TestViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TestViewController: UIViewController, IndicatorInfoProvider {

    private var msg : String = ""
    
    @IBOutlet weak var msgLabel: UILabel!
    
    func setMessage(msg : String) -> Void {
        self.msg = msg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        msgLabel.text = "Test \(msg) desu"
        
        // Do any additional setup after loading the view.
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: msg)
    }

}
