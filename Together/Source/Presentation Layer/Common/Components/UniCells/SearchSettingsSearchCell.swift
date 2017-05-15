//
//  SearchSettingsButtonsCell.swift
//  Together
//
//  Created by Андрей Цай on 19.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class SearchSettingsSearchCell: UITableViewCell {

    @IBOutlet weak var searchButtonView: SearchButtonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makePretty()
    }

    fileprivate func makePretty(){
        searchButtonView.setupView(
            horizontalMargin: 0,
            verticalMargin: 8)
        searchButtonView.addTarget(self, action: #selector(SearchSettingsSearchCell.searchButtonAction))
    }
    
    func searchButtonAction(){
        print("SearchButton action")
    }
    
}

extension SearchSettingsSearchCell: UniCell {
    func setupCellProfile(_ profileData: CellAbstractData) {
    }

    func setupCellData(_ cellData: CellAbstractData) {
    }
    
    func getCellData() -> CellAbstractData {
        return ["":0]
    }
}
