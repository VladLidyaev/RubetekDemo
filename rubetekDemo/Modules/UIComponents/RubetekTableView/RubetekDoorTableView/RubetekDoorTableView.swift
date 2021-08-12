//
//  RubetekDoorTableView.swift
//  rubetekDemo
//
//  Created by Vlad on 11.08.2021.
//

import UIKit

class RubetekDoorTableView: RubetekTableView {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.dataSection[indexPath.section].items[indexPath.row]
        if data.snapshot == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: Configurates.rubetekDoorCellID, for: indexPath) as! RubetekDoorCell
            cell.customInit(data as! DoorRubetek)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Configurates.rubetekCameraCellID, for: indexPath) as! RubetekCameraCell
            cell.customInit(data as! DoorRubetek)
            return cell
        }
    }
    
    private func updateData() {
        DoorRubetek.get { (result) in
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
        let edit = self.editCell(indexPath: indexPath)
        let actions = UISwipeActionsConfiguration(actions: [edit,favorite])
        return actions
    }
    
    private func favoriteCell(indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "like") { (_, _, _) in
            
            var selectedCell : RubetekCell? = nil
            let cell = self.cellForRow(at: indexPath) as? RubetekDoorCell
            if cell != nil {
                selectedCell = cell!
            } else {
                let cell = self.cellForRow(at: indexPath) as? RubetekCameraCell
                guard cell != nil else { fatalError() }
                selectedCell = cell!
            }
            
            let cellID = selectedCell!.dataID
            guard let id = cellID else { fatalError() }
            
            DoorRubetek.toggleFavorite(id: id) { (error) in
                guard error == nil else { fatalError() }
            }
            self.reloadData()
        }
        action.backgroundColor = .clear
        action.image = Configurates.likeActionImage
        return action
    }
    
    private func editCell(indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "edit") { (_, _, _) in
            
            var selectedCell : RubetekCell? = nil
            let cell = self.cellForRow(at: indexPath) as? RubetekDoorCell
            if cell != nil {
                selectedCell = cell!
            } else {
                let cell = self.cellForRow(at: indexPath) as? RubetekCameraCell
                guard cell != nil else { fatalError() }
                selectedCell = cell!
            }
            
            let cellID = selectedCell!.dataID
            guard let id = cellID else { fatalError() }
            
            self.showInputDialog(title: "Edit name", subtitle: "Please enter the new name.", actionTitle: "Edit", cancelTitle: "Cancel", inputPlaceholder: "Door name", inputKeyboardType: .default) { (_) in
                return
            } actionHandler: { (newName) in
                
                guard let name = newName else { return }
                guard newName != "" else { return }
                
                DoorRubetek.setNewName(id: id, newName: name) { (error) in
                    guard error == nil else { fatalError() }
                }
                self.updateData()
            }
        }
        action.backgroundColor = .clear
        action.image = Configurates.editActionImage
        return action
    }
    
    @objc override func refreshData(_ sender: UIRefreshControl) {
        DoorRubetek.update { (result) in
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
