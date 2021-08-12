//
//  ViewController.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import UIKit
import RealmSwift

class HomeViewController: RubetekViewController, PageSubscriber {
    
    @IBOutlet weak var control: ScrollPagesControl!
    @IBOutlet weak var pageView: ScrollPagesView!
    
    private var pagesTableView : [menuPages : RubetekTableView] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preparingPages()
    }
    
    private func preparingPages() {
        control.bindWith( menuPages.allCases.map { $0.rawValue }, view: pageView)
        pageView.bindWith(control)
        pageView.subscribeOnCurrentPage(self)
        
        for (index,tableView) in pageView.tableViewList.enumerated() {
            switch index {
            case 0:
                self.pagesTableView.updateValue((tableView as? RubetekCameraTableView)!, forKey: .cameras)
            case 1:
                self.pagesTableView.updateValue((tableView as? RubetekDoorTableView)!, forKey: .doors)
            default:
                return
            }
        }
        self.uploadPagesData()
    }
    
    private func uploadPagesData() {
        self.showCameraPage()
        self.showDoorPage()
    }
    
    private func showDoorPage() {
        DoorRubetek.get { (result) in
            switch result {
            case .success(let optionalData):
                
                guard let data = optionalData else { return }
                guard let tableView = self.pagesTableView[.doors] else { return}
                tableView.setData(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showCameraPage() {
        CameraRubetek.get { (result) in
            switch result {
            case .success(let optionalData):
                
                guard let data = optionalData else { return }
                guard let tableView = self.pagesTableView[.cameras] else { return }
                tableView.setData(data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func pagesViewUpdateCurrentPage(currentPage: Int) {
        print("====")
        print(currentPage)
        print(self.pagesTableView.count)
    }
}
