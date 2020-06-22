//
//  QHExcelView.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class QHExcelView: UIView {
    
    // MARK: - initial methods
     init(config: QHExcelConfig) {
        self.config = config
        super.init(frame: .zero)
        self.addSubview(self.contentView)
        if config.showBorder  {
            self.layer.borderColor = config.borderColor.cgColor
            self.layer.borderWidth = config.borderWidth
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - property
    
    private var config: QHExcelConfig


    // MARK: - UI
    private lazy var contentView: UICollectionView = {
        
        let collectionView = QHExcelCollectionView(config: self.config)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        
        self.sendSubviewToBack(self.contentView)
    }

}

// MARK: - UICollectionViewDataSource
extension QHExcelView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.config.showMenu  ? self.config.row + 1 : self.config.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.config.column
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kQHExcelCellTextIdentifier, for: indexPath) as! QHExcelCell
        cell.indexPath = indexPath
        if self.config.showMenu == true {
            switch indexPath.section {
            case 0:
                if indexPath.item < self.config.menuContents.count {
                    let element = self.config.menuContents[indexPath.item]
                    cell.config(icon: element.icon, title: element.title,isMenu: true,isFirstColumn: false,config: self.config)
                }
            default:
                if indexPath.section - 1 < self.config._contents.count {
                    if indexPath.item  < self.config._contents[indexPath.section - 1].count {
                        let element = self.config._contents[indexPath.section - 1][indexPath.item]
                        if indexPath.item == 0 {
                            cell.config(icon: element.icon, title: element.title,isMenu: false,isFirstColumn: true,config: self.config)
                        }
                        else {
                            cell.config(icon: element.icon, title: element.title,isMenu: false,isFirstColumn: false,config: self.config)
                        }
                        
                    }
                    else {
                        cell.config(icon: nil, title: "-",isMenu: false,isFirstColumn: false,config: self.config)
                    }
                }
                else {
                    cell.config(icon: nil, title: "-",isMenu: false,isFirstColumn: false,config: self.config)
                }
            }
        }
        else {
            if indexPath.section  < self.config._contents.count {
                if indexPath.item  < self.config._contents[indexPath.section].count {
                    let element = self.config._contents[indexPath.section][indexPath.item]
                    if indexPath.item == 0 {
                        cell.config(icon: element.icon, title: element.title,isMenu: true,isFirstColumn: false,config: self.config)
                    }
                    else {
                        cell.config(icon: element.icon, title: element.title,isMenu: false,isFirstColumn: false,config: self.config)
                    }
                }
                else {
                    cell.config(icon: nil, title: "-",isMenu: false,isFirstColumn: false,config: self.config)
                }
            }
            else {
                cell.config(icon: nil, title: "-",isMenu: false,isFirstColumn: false,config: self.config)
            }
        }
        

        
        return cell
    }
}

// MARK: - QHExcelCollectionViewLayoutDelegate
extension QHExcelView: QHExcelCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.config.contentsWidths[indexPath.item], height: self.config.contentsHeights[indexPath.section])
    }
    
    
}

