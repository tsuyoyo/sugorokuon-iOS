//
//  RegionListTableViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/10.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

class RegionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var viewModel : RegionListViewModel!
    private let disposeBag = DisposeBag()
    
    private var regions : Array<Region> = []
    private var selectedRegion : Region = Region.NO_REGION
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegionListViewModel(repository: RegionRepository.get())
        viewModel.regions
            .observeOn(MainScheduler.instance)
            .do(onNext: { allRegions in
                self.regions = allRegions
                self.reloadInputViews()
            })
            .subscribe()
            .addDisposableTo(disposeBag)
        viewModel.selectedRegion()
            .observeOn(MainScheduler.instance)
            .do(onNext: { selected in
                self.selectedRegion = selected
                self.reloadInputViews()
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionOption", for: indexPath)
        
        let label = cell.viewWithTag(1) as! UILabel
        
        let r = regions[indexPath.row]
        label.text = r.value().name
        if selectedRegion == r {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(region: regions[indexPath.row])
    }

}
