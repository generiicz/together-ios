//
//  TableView.swift
//  Together
//
//  Created by Андрей Цай on 02.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

enum UniTableDataSourceError: Error {
    case wrongSectionIndex
    case wrongRowIndex
    case cellsNotGenerated
}

enum UniTableViewCellsMode {
    case reusable
    case unique
}

typealias CellAbstractData = [String: Any]

struct CellMetaData{
    let identifier: String
    let nibName: String
    let rowHeight: CGFloat?
    var selectedClosure: ((IndexPath, CellAbstractData?) -> Void)?
    let profileData: CellAbstractData?
    let cellData: CellAbstractData?
    var cellObj: UITableViewCell?
    
    init(identifier: String, rowHeight: CGFloat?, cellData: CellAbstractData?, profileData: CellAbstractData?) {
        self.identifier = identifier
        self.nibName = identifier
        self.cellData = cellData
        self.profileData = profileData
        self.rowHeight = rowHeight
    }

    init(identifier: String, nibName: String, rowHeight: CGFloat?, cellData: CellAbstractData?, profileData: CellAbstractData?, selectedClosure: ((IndexPath, CellAbstractData?) -> Void)?) {
        self.identifier = identifier
        self.nibName = nibName
        self.cellData = cellData
        self.profileData = profileData
        self.rowHeight = rowHeight
        self.selectedClosure = selectedClosure
    }

}

enum SectionHeaderFooterType {
    case plainText(String)
    case richText(String, UIColor, CGFloat, CGFloat, UIColor)
    case searchButton(CGFloat)
    case searchField(CGFloat)
    case facebookSearchFriends(CGFloat)
    case customView(UIView, CGFloat)
    case none(CGFloat)
}

struct SectionMetaData {
    let headerType: SectionHeaderFooterType
    let footerType: SectionHeaderFooterType
    var cells: [CellMetaData]
}

class UniTableViewDataSource: NSObject {
    
    var cellsMode: UniTableViewCellsMode = .unique
    var defaultRowHeight: CGFloat = 128
    var autoDeselect: Bool = true
    fileprivate let standardHeaderFooterHeight: CGFloat = 34
    fileprivate var generated: Bool = false
    fileprivate var uniCells: [SectionMetaData] = []
    var sectionsCount: Int {
        get {
            return uniCells.count
        }
    }
    var cellsCount: [Int] {
        get {
            var res: [Int] = []
            for section in uniCells {
                res.append(section.cells.count)
            }
            return res
        }
    }
    var cellsOutputData: [[CellAbstractData]]{
        get{
            var res:[[CellAbstractData]] = []
            var lowres: [CellAbstractData] = []
            for (sectIndx, _) in uniCells.enumerated(){
                lowres.removeAll()
                for cell in uniCells[sectIndx].cells {
                    if let obj = cell.cellObj as? UniCell, let getDataFunc = obj.getCellData {
                        lowres.append(getDataFunc())
                    }
                }
                res.append(lowres)
            }
            return res
        }
    }
    
    func connectToTableView(_ tableView: UITableView){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = defaultRowHeight
    }
    
    func addSection(_ sectionData: SectionMetaData) {
        uniCells.append(sectionData)
    }
    
    func addCell(_ toSection: Int, reusableIdentifier: String, rowHeight: CGFloat?, cellData: CellAbstractData?, profileData: CellAbstractData?) throws {
        if uniCells.count > 0 && toSection < uniCells.count && toSection >= 0 {
            uniCells[toSection].cells.append(CellMetaData(identifier: reusableIdentifier, rowHeight: rowHeight, cellData: cellData, profileData: profileData))
        } else {
            throw UniTableDataSourceError.wrongSectionIndex
        }
    }
    
    func addCell(_ toSection: Int, reusableIdentifier: String, nibName: String, rowHeight: CGFloat?, cellData: CellAbstractData?, profileData: CellAbstractData?, selectedClosure: ((IndexPath, CellAbstractData?) -> Void)?) throws {
        if uniCells.count > 0 && toSection < uniCells.count && toSection >= 0 {
            uniCells[toSection].cells.append(CellMetaData(identifier: reusableIdentifier, nibName: nibName, rowHeight: rowHeight, cellData: cellData, profileData: profileData, selectedClosure: selectedClosure))
        } else {
            throw UniTableDataSourceError.wrongSectionIndex
        }
    }
    
    func updateCellsData(_ inSection: Int, range: CountableClosedRange<Int>?, updater: (UITableViewCell) -> Void) throws {
        guard generated else { throw UniTableDataSourceError.cellsNotGenerated }
        let actualRange = range != nil ? range! : 0...uniCells[inSection].cells.count - 1
        if actualRange.lowerBound >= 0 && actualRange.upperBound < self.uniCells[inSection].cells.count {
            for i in actualRange {
                if let cellObj = uniCells[inSection].cells[i].cellObj {
                    updater(cellObj)
                }
            }
        }
    }
    
    func updateAllCellsData(updater: (UITableViewCell) -> Void) throws {
        guard generated else { throw UniTableDataSourceError.cellsNotGenerated }
        for (i,k) in cellsCount.enumerated() {
            try updateCellsData(
                i,
                range: 0...k - 1,
                updater: updater)
        }
    }
    
    func clean() {
        uniCells.removeAll()
        //generated = false
    }
    
    func regenerateCells(_ tableView: UITableView) {
        generated = false
        generateCells(tableView)
    }
    
    func generateCells(_ tableView: UITableView) {
        if !generated {
            switch cellsMode {
            case .unique:
                generateUniqCells()
            case .reusable:
                generateReusableCells(tableView)
            }
            generated = true
        }
    }
    
    fileprivate func generateReusableCells(_ tableView: UITableView) {
        var res: [CellMetaData] = []
        for section in uniCells {
            for (_, cellTmp) in section.cells.enumerated() {
                let container = res.contains { cData in
                    return cData.identifier == cellTmp.identifier
                }
                if !container {
                    res.append(cellTmp)
                }
            }
        }
        for gCell in res {
            tableView.register(
                UINib(nibName: gCell.nibName, bundle: nil),
                forCellReuseIdentifier: gCell.identifier)
        }
    }
    
    fileprivate func generateUniqCells() {
        for (sectIndx, section) in uniCells.enumerated() {
            for (cellIndx, cellTmp) in section.cells.enumerated() {
                if uniCells[sectIndx].cells[cellIndx].cellObj == nil {
                    let nib = UINib(nibName: cellTmp.identifier, bundle: nil)
                    let cell =  nib.instantiate(withOwner: self, options: nil).first as! UniCell
                    if let profileData = uniCells[sectIndx].cells[cellIndx].profileData, let setupProfileFunc = cell.setupCellProfile {
                        setupProfileFunc(profileData)
                    }
                    uniCells[sectIndx].cells[cellIndx].cellObj = (cell as! UITableViewCell)
                }
            }
        }
    }
    
}
extension UniTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniCells[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTmp = uniCells[indexPath.section].cells[indexPath.row]
        var cell: UITableViewCell!
        switch cellsMode {
        case .unique:
            cell = cellTmp.cellObj!// REVIEW: Explicit unwrapping is bad.
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            if let uCell = cell as? UniCell, let cellParams = cellTmp.cellData {
                uCell.setupCellData(cellParams)
            }
        case .reusable:
            cell = tableView.dequeueReusableCell(
                withIdentifier: cellTmp.identifier,
                for: indexPath
            )
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            if let uCell = cell as? UniCell, let setupProfileFunc = uCell.setupCellProfile, let profileData = cellTmp.profileData, let cellData = cellTmp.cellData {
                setupProfileFunc(profileData)
                uCell.setupCellData(cellData)
            }
        }
        return cell
    }
}

extension UniTableViewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var res: CGFloat = defaultRowHeight
        let cData = self.uniCells[indexPath.section].cells[indexPath.row]
        guard let targetHeight = cData.rowHeight else { return res }
        res = targetHeight
        cData.cellObj?.setNeedsLayout()
        return res
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.autoDeselect {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        let cData = self.uniCells[indexPath.section].cells[indexPath.row]
        
        if let callBack = cData.selectedClosure, let cellObj = cData.cellObj as? UniCell, let getDataFunc = cellObj.getCellData {
            callBack(indexPath, getDataFunc())
        }
    }
    
    fileprivate func getViewForSectionHeaderFooter(_ type: SectionHeaderFooterType) -> UIView? {
        var res: UIView? = nil
        switch type {
        case .none(_):
            break
        case .customView(let view, _):
            res = view
        case .plainText(let title):
            res = UniTableDataSourceFactory.createSectionTitle(title)
        case .richText(let title, let fColor, let fSize, let fSpacing, let backgroundColor):
            res = UniTableDataSourceFactory.createSectionTitle(title, fontColor: fColor, fontSize: fSize, fontSpacing: fSpacing, backgroundColor: backgroundColor)
        case .searchButton(let height):
            res = UniTableDataSourceFactory.createSearchButton(height)
        case .searchField(let height):
            res = UniTableDataSourceFactory.createSearchField(height)
        case .facebookSearchFriends(let height):
            res = UniTableDataSourceFactory.createFacebookSearchFriends(height)
        }
        
        return res
    }
    
    fileprivate func getHeightForSectionHeaderFooter(_ type: SectionHeaderFooterType) -> CGFloat {
        var res: CGFloat = 0
        switch type {
        case .none(let height):
            res = height
        case .plainText:
            res = standardHeaderFooterHeight
        case .richText(_, _, let fSize, _, _):
            res = fSize + 16
        case .customView(_, let vSize):
            res = vSize
        case .searchButton(let height):
            res = height
        case .searchField(let height):
            res = height
        case .facebookSearchFriends(let height):
            res = height
        }
        return res
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = getViewForSectionHeaderFooter(uniCells[section].headerType)
        //tableView.sectionIndexBackgroundColor = view?.backgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getHeightForSectionHeaderFooter(uniCells[section].headerType)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = getViewForSectionHeaderFooter(uniCells[section].footerType)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return getHeightForSectionHeaderFooter(uniCells[section].footerType)
    }
}
