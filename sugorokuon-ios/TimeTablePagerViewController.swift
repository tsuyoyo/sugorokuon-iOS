//
//  TimeTablePagerTabStrip.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

// https://medium.com/michaeladeyeri/how-to-implement-android-like-tab-layouts-in-ios-using-swift-3-578516c3aa9 を参考に
class TimeTablePagerViewController: ButtonBarPagerTabStripViewController {

    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    private var disposeBag = DisposeBag()
    private var viewModel : TimeTablePagerViewModel?
    
    private var stationParser : XMLParser?
    private var stationParserDelegate : StationResponseParser?
    private var stations : Array<Station>?

    private let repository = TimeTableRepository()
    private let urlManager = UrlManager()
    
    override func viewDidLoad() {
        // Have to call before viewDidLoad()
        setupTabBar()
        super.viewDidLoad()
        bindViewModel()
        
        viewModel?.setArea(id: "JP13")
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var views : [UIViewController] = []
        
        self.stations?.forEach {
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "timetable")
            as! TimeTableViewController
            vc.setup(station: $0, day: .Monday, repository: repository, urlManager: urlManager)
            views.append(vc)
        }
        
        if views.isEmpty {
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "timetable") as! TimeTableViewController
            views.append(vc)
        }
        
        return views
    }
    
    private func setupTabBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
    }
    
    private func bindViewModel() {
        viewModel = TimeTablePagerViewModel(urlManager: urlManager)
        
        viewModel?
            .fetchedStations
            .subscribe { event -> Void in
                self.stations = event.element
                self.reloadPagerTabStripView()
            }
            .addDisposableTo(disposeBag)
    }
}
