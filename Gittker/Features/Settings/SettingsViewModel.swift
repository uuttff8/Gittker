//
//  SettingsViewModel.swift
//  Gittker
//
//  Created by uuttff8 on 3/25/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import AsyncDisplayKit

struct SettingsViewModel {
    weak var dataSource : GenericDataSource<TableGroupedSection>?
    
    init(dataSource : GenericDataSource<TableGroupedSection>?) {
        self.dataSource = dataSource
    }
    
    func fetchDataSourceUser() {
        guard let userdata = ShareData.init().userdata else { return }
        
        
        CachedUserLoader.init(cacheKey: userdata.username ?? "")
            .fetchData { (userSchema) in
                let profile = TableGroupedSection(section: .profile,
                                                  items:
                    [TableGroupedProfile(text: userdata.displayName ?? "",
                                         type: .gitter,
                                         value: userdata.username ?? "",
                                         avatarUrl: userdata.avatarURL ?? "",
                                         user: userSchema),
                    ],
                                                  footer: nil,
                                                  grouped: true)
                
                // Check if profile got cached value and update it
                if let index = self.dataSource!.data.value.firstIndex(where: { (section) -> Bool in
                    section.section == TableGroupedSectionType.profile
                }) {
                    var prof = self.dataSource!.data.value[index].items[0] as? TableGroupedProfile
                    prof?.user = userSchema
                    return
                }
                
                // if no cached value, then insert cell
                self.dataSource?.data.value.insert(profile, at: 0)
        }
    }
    
    func fetchDataSourceLocalData() {
        let logout = TableGroupedSection(section: .logout,
                                         items:
            [TableGroupedItem(text:  "Logout",
                              type: .noUrl,
                              value: "")
            ],
                                         footer: nil,
                                         grouped: true)
        
        
        self.dataSource?.data.value = [logout]
    }
}

class SettingsTableDelegates: GenericDataSource<TableGroupedSection>, ASTableDataSource, ASTableDelegate {
    var logoutAction: (() -> Void)? = nil
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.data.value.count
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.data.value[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            var cell: ASCellNode
            
            let section = self.data.value[indexPath.section]
            let item = section.items[indexPath.row]
            
            switch section.section {
            case .profile:
                guard let item2 = item as? TableGroupedProfile else { return ASCellNode() }
                cell = ProfileMainNodeCell(with: item2.user)
            case .logout:
                cell = SettingsButtonNodeCell(with: SettingsButtonNodeCell.Content(title: item.text))
                
            default:
                cell = ASCellNode()
            }
            
            return cell
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        node.setNeedsDisplay()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.data.value[section]
        
        return section.section.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = self.data.value[section]
        
        return section.footer
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let section = self.data.value[indexPath.section]
        //        let item = section.items[indexPath.row]
        
        switch section.section {
        case .profile:
            tableNode.deselectRow(at: indexPath, animated: true)
        case .logout:
            self.logoutAction?()
            tableNode.deselectRow(at: indexPath, animated: true)
            
        default:
            break
        }
        
    }  
}
