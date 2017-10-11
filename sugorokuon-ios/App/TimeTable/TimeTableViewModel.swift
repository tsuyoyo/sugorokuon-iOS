//
//  TimeTableViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

protocol TimeTableViewModelOutput {
    var fetchedPrograms : Observable<Array<Program>> { get }
}

class TimeTableViewModel {
    fileprivate let programs = BehaviorSubject<Array<Program>>(value: [])
    fileprivate let timeTable : TimeTable
    
    init(timeTable : TimeTable) {
        self.timeTable = timeTable
        programs.onNext(timeTable.programs)
    }
}

extension TimeTableViewModel : TimeTableViewModelOutput {
    var fetchedPrograms: Observable<Array<Program>> {
        return programs.asObservable()
    }
}
