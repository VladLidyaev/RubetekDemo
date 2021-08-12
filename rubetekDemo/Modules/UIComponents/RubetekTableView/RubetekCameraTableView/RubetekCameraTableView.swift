//
//  RubetekCameraTableView.swift
//  rubetekDemo
//
//  Created by Vlad on 11.08.2021.
//

import UIKit

class RubetekCameraTableView: RubetekTableView {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.dataSection[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Configurates.rubetekCameraCellID, for: indexPath) as! RubetekCameraCell
        cell.customInit(data as! CameraRubetek)
        return cell
    }
    
    private func updateData() {
        CameraRubetek.get { (result) in
            switch result {
            case .success(let data):
                guard let newData = data else { return }
                self.setData(newData)
            case .failure(_):
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = self.favoriteCell(indexPath: indexPath)
        let actions = UISwipeActionsConfiguration(actions: [favorite])
        return actions
    }
    
    private func favoriteCell(indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "like") { (_, _, _) in
            
            let cell = self.cellForRow(at: indexPath) as? RubetekCameraCell
            guard let selectedCell = cell else { fatalError() }
            
            let cellID = selectedCell.dataID
            guard let id = cellID else { fatalError() }
            
            CameraRubetek.toggleFavorite(id: id) { (error) in
                guard error == nil else { fatalError() }
            }
            self.reloadData()
        }
        action.backgroundColor = .clear
        action.image = Configurates.likeActionImage
        return action
    }
    
    @objc override func refreshData(_ sender: UIRefreshControl) {
        CameraRubetek.update { (result) in
            switch result {
            case .success(let data):
                self.setData(data)
                DispatchQueue.main.async {
                    sender.endRefreshing()
                }
            case .failure(_):
                return
            }
        }
    }
}
