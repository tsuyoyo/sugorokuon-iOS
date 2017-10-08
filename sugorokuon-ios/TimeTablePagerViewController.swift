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
class TimeTablePagerViewController: ButtonBarPagerTabStripViewController, DateSelectorViewControllerDelegate {

    let purpleInspireColor = UIColor(red:3/255, green:155/255, blue:229/255, alpha:1.0)

    private var disposeBag = DisposeBag()
    private var viewModel : TimeTablePagerViewModel!
    
    private var stationParser : XMLParser?
    private var stationParserDelegate : StationResponseParser?
    
    private var stations : Array<Station> = []
    private var timeTables : Array<TimeTable> = []

    private let repository = TimeTableRepository()
    private let urlManager = UrlManager()
    
    override func viewDidLoad() {
        // Have to call before viewDidLoad()
        setupTabBar()
        super.viewDidLoad()
        bindViewModel()
        viewModel.setAreaAndDate(region: "JP13", date: Date())
    }
    
    @IBAction func onDateSelectClicked(_ sender: Any) {
        let datePicker = UIStoryboard(name: "DateSelect", bundle: nil)
            .instantiateViewController(withIdentifier: "dateSelect")
            as! DateSelectViewController
        
        datePicker.modalPresentationStyle = .overCurrentContext
        if let dateStr = self.navigationItem.title,
            let currentDate = getDateFormatForTitle().date(from: dateStr) {
            datePicker.set(date: currentDate)
        }
        
        datePicker.delegate = self
        present(datePicker, animated: true, completion: nil)
    }
    
    private func getDateFormatForTitle() -> DateFormatter {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var views : [UIViewController] = []
        
        self.stations.forEach { station in
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "timetable")
            as! TimeTableViewController

            let filtered = self.timeTables.filter { t -> Bool in
                return t.stationId == station.id
            }
            if !filtered.isEmpty {
                vc.setup(station: station, timeTable: filtered[0])
                views.append(vc)
            }
        }
        
        if views.isEmpty {
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "timetable") as! TimeTableViewController
            views.append(vc)
        }
        
        return views
    }
    
    // MARK : - DateSelectorViewControllerDelegate
    func onDateSelected(date: Date) {
        viewModel.setAreaAndDate(region: "JP13", date: date)
    }
    
    private func setupTabBar() {
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        
        settings.style.buttonBarBackgroundColor = UIColor(red: 225/255, green: 245/255, blue: 254/255, alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0xE1, green: 0xF5, blue: 0xFE, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .red
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
        viewModel = TimeTablePagerViewModel(
            stationApi: StationApi(urlManager: urlManager),
            timeTableApi: TimeTableApi(urlManager: urlManager)
        )
        
        Observable.combineLatest(
            viewModel.fetchedStations,
            viewModel.fetchedTimeTable) { (stations, timeTables) -> Bool in
                self.stations = stations
                self.timeTables = timeTables
                self.reloadPagerTabStripView()
                return true
            }
            .subscribeOn(MainScheduler.instance)
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.selectedDate
            .subscribeOn(MainScheduler.instance)
            .do(onNext: self.setTitle)
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.isFetching
            .observeOn(MainScheduler.instance)
            .do(onNext: { fetching in
//                self.loading.isHidden = !fetching
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    private func setTitle(date: Date) {
        self.navigationItem.title = getDateFormatForTitle().string(from: date)
    }
}
