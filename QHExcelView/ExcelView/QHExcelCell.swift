//
//  QHExcelCell.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit


let kQHExcelCellTextIdentifier = "kQHExcelCellTextIdentifier"

class QHExcelCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.removeFromSuperview()
        self.titleLabel.frame = .zero
        self.icon.removeFromSuperview()
        self.icon.frame = .zero
        
//        self.yAxisLine.removeFromSuperview()
//        self.yAxisLine.frame = .zero
//        self.xAxisLine.removeFromSuperview()
//        self.xAxisLine.frame = .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    // MARK: -  configContent
    func config(icon: UIImage?,title:String?,titleColor: UIColor? = nil,isMenu: Bool = false,isFirstColumn: Bool = false,config: QHExcelConfig) {
        self.icon.image = icon
        self.icon.isHidden = icon == nil
        self.titleLabel.text = title ?? config.emptyTitle
    
        if isMenu {
            self.titleLabel.font = config.menuTitleFont
            self.titleLabel.textColor = titleColor ?? config.menuTitleColor
            self.contentView.backgroundColor = config.menuBackgroundColor
            self.titleLabel.numberOfLines = config.menuLineNubmer
        }
        else {
            if isFirstColumn {
                self.titleLabel.font = config.firstColumnFont
                self.titleLabel.textColor = titleColor ?? config.firstColumnColor
                self.contentView.backgroundColor = config.firstColumnBackgroundColor
                self.titleLabel.numberOfLines = config.contentLineNubmer
            }
            else {
                self.titleLabel.font = config.contentFont
                self.titleLabel.textColor = config.contentColor
                self.contentView.backgroundColor = config.contentBackgroundColor
                self.titleLabel.numberOfLines = config.contentLineNubmer
            }
        }
        self.setUpUI(config: config,contentEdgeInsets: isMenu ? config.menuEdggetInset : config.contentEdgeInsets)
    }
    
    // MARK: - property
    var indexPath: IndexPath?
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let xAxisLine: UIView = {
        let line = UIView()
        return line
    }()
    
    private let yAxisLine: UIView = {
        let line = UIView()
        return line
    }()
    
    private func setUpUI(config: QHExcelConfig,contentEdgeInsets: UIEdgeInsets) {
        
        if self.icon.isHidden == false {
            
            self.contentView.addSubview(self.titleLabel)
            self.contentView.addSubview(self.icon)
            self.icon.frame.size = config.contentIconSize

            self.icon.frame.origin.x = contentEdgeInsets.left
            self.icon.frame.origin.y = (self.bounds.height - self.icon.image!.size.height) * 0.5
            
            self.titleLabel.frame.origin.x = self.icon.frame.origin.x + config.contentIconSize.width + config.titleAndIconMargin
            self.titleLabel.frame.size.width = self.bounds.width - self.titleLabel.frame.origin.x - contentEdgeInsets.right
            self.titleLabel.frame.size.height = self.titleLabel.sizeThatFits(CGSize(width: self.titleLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            self.titleLabel.center.y = self.icon.center.y
            self.titleLabel.textAlignment = .left
        }
        else {
            self.contentView.addSubview(self.titleLabel)
            self.titleLabel.frame.origin.x = contentEdgeInsets.left
            self.titleLabel.frame.size.width = self.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right
            self.titleLabel.frame.size.height = self.bounds.height
            self.titleLabel.textAlignment = .center
        }
        
        guard let column = self.indexPath else { return }
        let needShowYAxia = column.item < config.column - 1
        self.contentView.addSubview(self.xAxisLine)
        self.xAxisLine.isHidden = !(needShowYAxia && config.showYAxiaiLine)
        self.xAxisLine.frame = CGRect(x: self.bounds.width - config.xAxisHWidth, y: 0, width: config.xAxisHWidth, height: self.bounds.height)
        self.xAxisLine.backgroundColor = config.yAxisColor

        let needShowXAxia = config.showMenu ? column.section < config.row : column.row < config.row - 1
        self.contentView.addSubview(self.yAxisLine)
        self.yAxisLine.isHidden = column.section == 0 ? false : !(config.showXAisLine && needShowXAxia)
        self.yAxisLine.frame = CGRect(x: 0, y: self.bounds.height - config.yAxisHeight, width: self.bounds.width, height: config.yAxisHeight )
        self.yAxisLine.backgroundColor = config.xAxisColor
    }
}
