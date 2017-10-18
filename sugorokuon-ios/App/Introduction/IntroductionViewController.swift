//
//  IntroduceViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

protocol IntroductionViewDelegate {
    func onClosed()
}

class IntroductionViewController:
    UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let disposeBag = DisposeBag()
    private var delegate : IntroductionViewDelegate?
    private var viewModel : IntroductionViewModel!
    
    private var regions : Array<Region> = []
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = IntroductionViewModel(
            regionRepository: RegionRepository.get())
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.regions
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (regions) in
                self.regions = regions
                self.reloadInputViews()
            })
            .addDisposableTo(disposeBag)
        
        viewModel.closeButtonAvailability
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (isAvailable) in
                self.closeButton.isEnabled = isAvailable
            })
            .addDisposableTo(disposeBag)
    }
    
    func set(delegate : IntroductionViewDelegate) {
        self.delegate = delegate
    }

    @IBAction func onCloseTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.onClosed()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "initRegionCell", for: indexPath)
        
        (cell.viewWithTag(1) as? UILabel)?.text
            = regions[indexPath.row].value().name
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(region: regions[indexPath.row])
    }
}
