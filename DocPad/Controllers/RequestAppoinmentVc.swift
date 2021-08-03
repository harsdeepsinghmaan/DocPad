//
//  RequestAppoinmentVc.swift
//  DocPad
//
//  Created by DeftDeskSol on 03/05/19.
//  Copyright © 2019 DeftDeskSol. All rights reserved.
//

import UIKit
import EventKit
import DropDown

class RequestAppoinmentVc: UIViewController, CalendarViewDataSource, CalendarViewDelegate  {

    @IBOutlet weak var calenderVw: CalendarView!
    @IBOutlet weak var btnDoctorOutlet: UIButton!
    @IBOutlet weak var heightOfNavigationbar: NSLayoutConstraint!
    
    let dropDown = DropDown()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if ((UIDevice.current.screenType.rawValue == "iPhone XS Max") || (UIDevice.current.screenType.rawValue == "iPhone XR") || (UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS")) {
            self.heightOfNavigationbar.constant = 80
        }
        else{
            self.heightOfNavigationbar.constant = 64
        }
        calenderVw.headerView.nextButton.addTarget(self, action: #selector(RequestAppoinmentVc.nextMonth), for: .touchUpInside)
        calenderVw.headerView.prevButton.addTarget(self, action: #selector(RequestAppoinmentVc.previousMonth), for: .touchUpInside)
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        //       CalendarView.Style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        //       CalendarView.Style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        //       CalendarView.Style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.headerTextColor          = UIColor.black
        CalendarView.Style.cellTextColorDefault     = UIColor.black
        CalendarView.Style.cellTextColorToday       = UIColor.black
        CalendarView.Style.cellTextColorWeekend       = UIColor.black
        CalendarView.Style.cellSelectedColor = UIColor(red: 46.00/225.00, green: 125/225.00, blue: 50/225.00, alpha: 1.0)
        //        CalendarView.Style.cellColorToday =  UIColor.red
        CalendarView.Style.cellSelectedBorderColor  = UIColor.clear
        CalendarView.Style.firstWeekday             = .monday
        
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        
        calenderVw.dataSource = self
        calenderVw.delegate = self
        
        calenderVw.direction = .horizontal
        calenderVw.multipleSelectionEnable = false
        calenderVw.marksWeekends = true
        
        
        //        calenderVw.backgroundColor = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        calenderVw.backgroundColor = UIColor.white
    }
    
    @objc func nextMonth(sender: UIButton)
    {
        self.calenderVw.goToNextMonth()
    }
    
    @objc func previousMonth(sender: UIButton)
    {
        self.calenderVw.goToPreviousMonth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let today = Date()
        
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        
        let tomorrow = self.calenderVw.calendar.date(byAdding: tomorrowComponents, to: today)!
        self.calenderVw.selectDate(tomorrow)
        
        #if KDCALENDAR_EVENT_MANAGER_ENABLED
        self.calendarView.loadEvents() { error in
            if error != nil {
                let message = "The karmadust calender could not load system events. It is possibly a problem with permissions"
                let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        #endif
        
        
        self.calenderVw.setDisplayDate(today)
        
        //        self.datePicker.locale = CalendarView.Style.locale
        //        self.datePicker.timeZone = CalendarView.Style.timeZone
        //        self.datePicker.setDate(today, animated: false)
    }
    
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = -2
        
        let today = Date()
        
        let threeMonthsAgo = self.calenderVw.calendar.date(byAdding: dateComponents, to: today)!
        
        return threeMonthsAgo
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.year = 2
        let today = Date()
        
        let twoYearsFromNow = self.calenderVw.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
        
    }
    
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
        print("Did Select: \(date) with \(events.count) events")
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
        
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
        //        self.datePicker.setDate(date, animated: true)
    }
    
    
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
        
        if let events = events {
            for event in events {
                print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
            }
        }
        
        let alert = UIAlertController(title: "Create New Event", message: "Message", preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Event Title"
        }
        
        let addEventAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
            let title = alert.textFields?.first?.text
            //            self.calenderVw.addEvent(title!, date: date)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(addEventAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK : Events
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        //        self.calendarView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        //        self.calendarView.goToPreviousMonth()
    }
    @IBAction func goToNextMonth(_ sender: Any) {
        //        self.calendarView.goToNextMonth()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
    // MARK: - Button Action
    
    @IBAction func btnDropDown(_ sender: Any) {
         dropDown.direction = .bottom
        dropDown.bottomOffset = .init(x: 0, y: 35)
        dropDown.anchorView = btnDoctorOutlet  // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Sofia", "Robin","Sofiaa", "Robins",]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.btnDoctorOutlet.setTitle(item, for: .normal)
            self.btnDoctorOutlet.setTitleColor(UIColor.black, for: .normal)
            
            
            self.dropDown.hide()
           
        }
        dropDown.show()

        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
