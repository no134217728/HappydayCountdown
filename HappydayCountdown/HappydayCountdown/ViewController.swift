//
//  ViewController.swift
//  HappydayCountdown
//
//  Created by Wei Jen Wang on 2022/9/12.
//

import UIKit

import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var nextMoneyDay: UILabel!
    @IBOutlet weak var nextMoneyCountdown: UILabel!
    @IBOutlet weak var nextLongHoliday: UILabel!
    @IBOutlet weak var nextLongHolidayTitle: UILabel!
    @IBOutlet weak var nextLongHolidayCountdown: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        today.text = ""
        nextMoneyDay.text = ""
        nextMoneyCountdown.text = ""
        nextLongHoliday.text = ""
        nextLongHolidayCountdown.text = ""
        
        bindData()
    }
    
    private func bindData() {
        Utilities.shared.todayDate.bind(to: today.rx.text).disposed(by: disposeBag)
        Utilities.shared.nextMoneyDate.bind(to: nextMoneyDay.rx.text).disposed(by: disposeBag)
        Utilities.shared.toNextMoneyDays.bind(to: nextMoneyCountdown.rx.text).disposed(by: disposeBag)
        Utilities.shared.nextLongHolidayDate.bind(to: nextLongHoliday.rx.text).disposed(by: disposeBag)
        Utilities.shared.toNextLongHolidayDaysTitle.bind(to: nextLongHolidayTitle.rx.text).disposed(by: disposeBag)
        Utilities.shared.toNextLongHolidayDays.bind(to: nextLongHolidayCountdown.rx.text).disposed(by: disposeBag)
    }
    
    @objc func becomeActive(_ notification: Notification)  {
        today.text = Utilities.shared.takeStringFromUserDefault(theKey: .todayDate)
        nextMoneyDay.text = Utilities.shared.takeStringFromUserDefault(theKey: .nextMoneyDate)
        nextMoneyCountdown.text = Utilities.shared.takeStringFromUserDefault(theKey: .toNextMoneyDays)
        nextLongHoliday.text = Utilities.shared.takeStringFromUserDefault(theKey: .nextLongHolidayDate)
        nextLongHolidayTitle.text = Utilities.shared.takeStringFromUserDefault(theKey: .toNextLongHolidayDaysTitle)
        nextLongHolidayCountdown.text = Utilities.shared.takeStringFromUserDefault(theKey: .toNextLongHolidayDays)
    }
}


