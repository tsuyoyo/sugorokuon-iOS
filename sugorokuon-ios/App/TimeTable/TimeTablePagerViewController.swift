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
class TimeTablePagerViewController: ButtonBarPagerTabStripViewController,
    DateSelectorViewControllerDelegate, HomeTabBarDelegate, IntroductionViewDelegate {

    let purpleInspireColor = UIColor(red:3/255, green:155/255, blue:229/255, alpha:1.0)

    private var disposeBag = DisposeBag()
    private var viewModel : TimeTablePagerViewModel!
    
    private var stationParser : XMLParser?
    private var stationParserDelegate : StationResponseParser?
    
    private var stations : Array<Station> = []
    private var timeTables : Array<TimeTable> = []

    private let repository = TimeTableRepository()
    private let urlManager = UrlManager()
    private let radikoDateUtil = RadikoDateUtil()
    
    private var titleLabel : UILabel!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var nextDayButton: UIBarButtonItem!
    @IBOutlet weak var previousDayButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        // Have to call before viewDidLoad()
        setupTabBar()
        super.viewDidLoad()
        setupNavigationTitle()
        bindViewModel()
    }
    
    private func setupNavigationTitle() {
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(TimeTablePagerViewController.onTitleTapped(sender:))
        )
        titleLabel.addGestureRecognizer(gestureRecognizer)
        
        titleLabel.isUserInteractionEnabled = true
        self.navigationItem.titleView = titleLabel
    }
    
    @IBAction func onNextDayTapped(_ sender: Any) {
        viewModel.fetchNextDay()
    }

    @IBAction func onPreviousDayTapped(_ sender: Any) {
        viewModel.fetchPreviousDay()
    }
    
    func onTitleTapped(sender: UITapGestureRecognizer) {
        showDatePicker()
    }
    
    func onClosed() {
        viewModel.closeIntroduction()
    }
    
    private func getDateFormatForTitle() -> DateFormatter {
        let formatter : DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier:"ja_JP")
        formatter.dateFormat = "yyyy/MM/dd(E)"
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
                vc.setup(station: station, timeTable: filtered[0], radikoDateUtil: radikoDateUtil)
                views.append(vc)
            }
        }
        
        if views.isEmpty {
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "timetable") as! TimeTableViewController
            views.append(vc)
        }
        
        return views
    }
    
    // MARK : - HomeTabBarDelegate
    func didTabSelected() {
        viewModel.fetchToday()
    }
    
    // MARK : - DateSelectorViewControllerDelegate
    func onDateSelected(date: Date) {
        viewModel.setDate(date: date)
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
            timeTableApi: TimeTableApi(urlManager: urlManager),
            regionRepository: RegionRepository.get(),
            radikoDateUtil: RadikoDateUtil()
        )

        Observable
            .combineLatest(
                viewModel.fetchedStations,
                viewModel.fetchedTimeTable
            )
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (stations, timetables) in
                self.stations = stations
                self.timeTables = timetables
                self.reloadPagerTabStripView()
            })
            .addDisposableTo(disposeBag)
        
        viewModel
            .selectedDate
            .observeOn(MainScheduler.instance)
            .do(onNext : { date in
                self.titleLabel.text = self.getDateFormatForTitle().string(from: date)
                self.titleLabel.sizeToFit()
            })
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.isFetching
            .observeOn(MainScheduler.instance)
            .do(onNext: { fetching in
                self.loading.isHidden = !fetching
            })
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.isNextDayAvailable
            .observeOn(MainScheduler.instance)
            .do(onNext: { nextDayAvailable in
                self.nextDayButton.isEnabled = nextDayAvailable
                if nextDayAvailable {
                    self.nextDayButton.tintColor = UIColor.white
                } else {
                    self.nextDayButton.tintColor = UIColor.gray
                }
            })
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.isPreviousDayAvailable
            .observeOn(MainScheduler.instance)
            .do(onNext: { previousDayAvailable in
                self.previousDayButton.isEnabled = previousDayAvailable
                if previousDayAvailable {
                    self.previousDayButton.tintColor = UIColor.white
                } else {
                    self.previousDayButton.tintColor = UIColor.gray
                }
            })
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // To appear viewController, timing should be after viewDidApper.
        // https://makotton.com/2015/01/16/735
        viewModel.showIntroduction
            .observeOn(MainScheduler.instance)
            .filter({ noRegion -> Bool in noRegion })
            .do(onNext: { noRegion in
                if let introduction = self.storyboard?.instantiateViewController(
                        withIdentifier: "introduction"
                    ) as? IntroductionViewController {
                    
                    introduction.set(delegate: self)
                    self.present(
                        introduction,
                        animated: true,
                        completion: nil
                    )
                }
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    private func showDatePicker() {
        let datePicker = UIStoryboard(name: "DateSelect", bundle: nil)
            .instantiateViewController(withIdentifier: "dateSelect")
            as! DateSelectViewController
        
        datePicker.modalPresentationStyle = .overCurrentContext
        if let dateStr = self.navigationItem.title,
            let currentDate = getDateFormatForTitle().date(from: dateStr) {
            datePicker.set(date: currentDate)
        } else {
            datePicker.set(date: Date())
        }
        
        datePicker.delegate = self
        present(datePicker, animated: true, completion: nil)
    }
        
    private func setTitle(date: Date) {
        self.navigationItem.title = getDateFormatForTitle().string(from: date)
    }
}
