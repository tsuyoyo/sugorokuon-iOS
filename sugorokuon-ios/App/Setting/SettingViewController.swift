//
//  SettingViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/07.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "settingItem")!
        let label = cell.viewWithTag(1) as! UILabel
        
        switch indexPath.row {
        case 0:
            label.text = "番組表を見たい地域"
            break
        case 1:
            label.text = "License"
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            launchRegionList()
            table.deselectRow(at: indexPath, animated: false)
            break
        case 1:
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func launchRegionList() -> Void {
        let regionViewController = self.storyboard?
            .instantiateViewController(withIdentifier: "regionListViewController")
            as! RegionListViewController
        self.navigationController?.pushViewController(
            regionViewController, animated: true)
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
