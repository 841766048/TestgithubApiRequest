//
//  PictureChoiceCell.swift
//  App
//
//  Created by 张海彬 on 2021/1/21.
//

import UIKit

class PictureChoiceCell: UITableViewCell {
    
    //图片集合列表
    @IBOutlet var collectionView: UICollectionView!
    //collectionView的高度约束
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    // 封面数据源
    var  images:[ UIImage ] = []
    // 展示的数据
    var  show_images:[UIImage] = []
    // 选择的相册数据源
    var  selectedAssets:[HXPHAsset] = []
    
    var  selectedAssetsImage:[UIImage] = []
    var reloadBlock:parameterNoreturn?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //设置collectionView的代理
        self .collectionView.delegate =  self
        self .collectionView.dataSource =  self
        
        // 注册CollectionViewCell
        self .collectionView!.register( UINib (nibName: "PictureChoiceShowCell" , bundle: nil ),
                                        forCellWithReuseIdentifier:  "PictureChoiceShowCell" )
    }
    //加载数据
    func  reloadData( images:[UIImage]) {
        show_images.removeAll()
        //保存图片数据
        for  image in images {
            show_images.append(image)
        }
        if images.count < 9 {
            show_images.append(UIImage(named: "picSelection_icon")!)
        }
        self.images = images
        reloadData()
    }
    
    func reloadData() {
        //collectionView重新加载数据
        self .collectionView.reloadData()
        
        //更新collectionView的高度约束
        let  contentSize =  self .collectionView.collectionViewLayout.collectionViewContentSize
        collectionViewHeight.constant = contentSize.height
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension PictureChoiceCell :UICollectionViewDelegate , UICollectionViewDataSource {
    //返回collectionView的单元格数量
    func  collectionView(_ collectionView:  UICollectionView ,
                         numberOfItemsInSection section:  Int ) ->  Int  {
        return  show_images.count
    }
    
    //返回对应的单元格
    func  collectionView(_ collectionView:  UICollectionView ,
                         cellForItemAt indexPath:  IndexPath ) ->  UICollectionViewCell  {
        let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier:  "PictureChoiceShowCell" ,
                                                        for : indexPath)  as! PictureChoiceShowCell
        
        cell.iconImageView.image =  show_images[indexPath.item]
        cell.deleteBlock = { [weak self] in
            if var images = self?.images  {
                if indexPath.row < images.count  {
                    if var selectedAssets =  self?.selectedAssets {
                        let difference = images.count - selectedAssets.count
                        let index = indexPath.row - difference
                        if index < selectedAssets.count && index >= 0 {
                            selectedAssets.remove(at: index)
                            self!.selectedAssetsImage.remove(at: index)
                        }
                        self?.selectedAssets = selectedAssets;
                    }
                    images.remove(at: indexPath.row)
                }
                
                self?.reloadData(images:images)
                if let block = self?.reloadBlock {
                    block(images)
                }
            }
        }
        if (images.count != show_images.count && indexPath.row == show_images.count - 1)  {
            cell.deleteBtn.isHidden = true
        }else{
            cell.deleteBtn.isHidden = false
        }
        
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count && images.count < show_images.count {
            presentPickerController()
        }
    }
    
    //绘制单元格底部横线
    override  func  draw(_ rect:  CGRect ) {
        //线宽
        let  lineWidth = 1 /  UIScreen .main.scale
        //线偏移量
        let  lineAdjustOffset = 1 /  UIScreen .main.scale / 2
        //线条颜色
        let  lineColor =  UIColor (red: 0xe0/255, green: 0xe0/255, blue: 0xe0/255, alpha: 1)
        
        //获取绘图上下文
        guard  let  context =  UIGraphicsGetCurrentContext ()  else  {
            return
        }
        
        //创建一个矩形，它的所有边都内缩固定的偏移量
        let  drawingRect =  self .bounds.insetBy(dx: lineAdjustOffset, dy: lineAdjustOffset)
        
        //创建并设置路径
        let  path =  CGMutablePath ()
        path.move(to:  CGPoint (x: drawingRect.minX, y: drawingRect.maxY))
        path.addLine(to:  CGPoint (x: drawingRect.maxX, y: drawingRect.maxY))
        
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置笔触宽度
        context.setLineWidth(lineWidth)
        
        //绘制路径
        context.strokePath()
    }
    
    func presentPickerController() {
        // 自带的与微信一致的配置
        let config = HXPHTools.getWXConfig()
        let pickerController = HXPHPickerController.init(picker: config)
        pickerController.pickerControllerDelegate = self
        // 当前被选择的资源对应的 HXPHAsset 对象数组
        pickerController.selectedAssetArray = selectedAssets
        // 是否选中原图
        pickerController.isOriginal = true
        NSObject().appearController()?.present(pickerController, animated: true, completion: nil)
    }
}

extension PictureChoiceCell: HXPHPickerControllerDelegate {
    /// 选择完成之后调用，单选模式下不会触发此回调
    func pickerController(_ pickerController: HXPHPickerController, didFinishWith selectedAssetArray: [HXPHAsset], _ isOriginal: Bool) {
    
        images.removeAll(where: {[weak self] (img) -> Bool in
            (self?.selectedAssetsImage.contains(img) ?? false)
        })
        
        selectedAssets.removeAll()
        selectedAssetsImage.removeAll()
        
        for asset in selectedAssetArray {
            if let image = asset.originalImage  {
                selectedAssets.append(asset)
                images.append(image)
                selectedAssetsImage.append(image)
            }
        }
        show_images.removeAll()
        //保存图片数据
        for image in images {
            show_images.append(image)
        }
        if images.count < 9 {
            show_images.append(UIImage(named: "picSelection_icon")!)
        }
		reloadData()
        if let block = reloadBlock {
            block(images)
        }
    }
}
