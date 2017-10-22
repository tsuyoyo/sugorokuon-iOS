//
//  TImeTableViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift
import XLPagerTabStrip
import SDWebImage

class TimeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    private let disposeBag = DisposeBag()

    private var viewModel : TimeTableViewModel!
    private var station : Station!
    private var radikoDateUtil: RadikoDateUtil!
    private var programs : Array<Program> = []
    
    @IBOutlet weak var table: UITableView!

    func setup(station: Station, timeTable: TimeTable, radikoDateUtil: RadikoDateUtil) {
        viewModel = TimeTableViewModel(timeTable: timeTable, radikoDateUtil: radikoDateUtil)
        self.station = station
        self.radikoDateUtil = radikoDateUtil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindViewModel() {
        viewModel?.fetchedPrograms
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                if let programs = event.element {
                    self.programs = programs
                } else {
                    self.programs = []
                }
                self.table.reloadData()
            }
            .addDisposableTo(disposeBag)
        
        viewModel?.onAirProgramIndex
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { focusedIndex -> Void in
                let indexPath = IndexPath(row: focusedIndex, section: 0)
                self.table.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                self.table.deselectRow(at: indexPath, animated: false)
            })
            .addDisposableTo(disposeBag)
    }

    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(
            withIdentifier: "programCell", for: indexPath)

        let title = table.viewWithTag(1) as! UILabel?
        let personalities = table.viewWithTag(2) as! UILabel?
        let image = table.viewWithTag(3) as! UIImageView?
        let start = table.viewWithTag(4) as! UILabel?
        let end = table.viewWithTag(5) as! UILabel?
        
        let p = programs[indexPath.row]
        title?.text = p.title
        personalities?.text = p.personality
        
        image?.clipsToBounds = true
        image?.layer.cornerRadius = (image?.frame.height)! / 2
        
        if let imageUrl = p.image {
            image?.sd_setImage(with: URL(string: imageUrl))
        } else if let stationImageUrl = station?.logoUrl {
            image?.sd_setImage(with: URL(string: stationImageUrl))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        start?.text = dateFormatter.string(from: p.startTime)
        end?.text = dateFormatter.string(from: p.endTime)
        
        return cell
    }
    
    // Cell が選択された場合
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let bottomSheet = UIStoryboard(name: "TimeTable", bundle: nil)
            .instantiateViewController(withIdentifier: "programDescription")
            as! ProgramDescriptionViewController

        bottomSheet.modalPresentationStyle = .overCurrentContext
        bottomSheet.set(program: programs[indexPath.row])
        present(bottomSheet, animated: true, completion: nil)
        
        table.deselectRow(at: indexPath, animated: false)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let stationName = station?.name {
            return IndicatorInfo(title: stationName)
        } else {
            return IndicatorInfo(title: "No station name")
        }
    }
}
