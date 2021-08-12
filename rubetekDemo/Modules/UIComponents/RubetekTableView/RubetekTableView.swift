//
//  RubetekTableView.swift
//  rubetekDemo
//
//  Created by Vlad on 10.08.2021.
//

import Foundation
import UIKit

struct RubetekSectionModel {
    var title : String
    var items : [RubetekObject]
}


class RubetekTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    internal var dataSection : [RubetekSectionModel] = []
    
    init(frame: CGRect, pageIndex : Int) {
        super.init(frame: frame, style: UITableView.Style.plain)
        self.tableViewConfig()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.tableViewConfig()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.tableViewConfig()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.dataSection.count > section else { return 0 }
        return self.dataSection[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configurates.rubetekCameraCellID, for: indexPath)
        cell.textLabel?.text = "No data"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Configurates.rubetekTableViewHeaderID) as! RubetekTableViewHeader
        header.titleLabel.text = self.dataSection[section].title
        return header
    }
    
//
//      SELECTED ROW
//
    
    public func setData(_ data : [RubetekObject]) {
        self.dataSection = self.getSection(data: data)
        self.reloadData()
    }
    
    private func tableViewConfig() {
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        
        self.register(UINib(nibName: Configurates.rubetekCameraCellID, bundle: nil), forCellReuseIdentifier: Configurates.rubetekCameraCellID)
        self.register(UINib(nibName: Configurates.rubetekDoorCellID, bundle: nil), forCellReuseIdentifier: Configurates.rubetekDoorCellID)
        self.register(UINib(nibName: Configurates.rubetekTableViewHeaderID, bundle: nil), forHeaderFooterViewReuseIdentifier: Configurates.rubetekTableViewHeaderID)
        
        self.tableFooterView = UIView()
        self.addRefreshController()
    }
    
    private func passData(cell : RubetekCell) {
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.setImage(image: cell.dataImage!)
        vc.setTitle(title: cell.dataTitle ?? "Unknown")
        let parentVC = self.parentViewController
        parentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getSection(data : [RubetekObject]) -> [RubetekSectionModel] {
        var dictionary : [ String : [RubetekObject]] = [:]
        data.forEach { (object) in
            let room = object.room!
            if (dictionary[room] == nil) {
                dictionary[room] = [object]
            } else {
                dictionary[room]!.append(object)
            }
        }
        return dictionary
            .map { RubetekSectionModel(title: $0.key, items: $0.value) }
            .sorted { $0.title < $1.title }
    }
    
    private func addRefreshController() {
        let refreshControl : UIRefreshControl = {
            let rc = UIRefreshControl()
            rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            return rc
        }()
        self.refreshControl = refreshControl
    }
    
    @objc internal func refreshData(_ sender : UIRefreshControl) {}
}
