//
//  HXPHPickerController.swift
//  照片选择器-Swift
//
//  Created by Silence on 2020/11/9.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit
import Photos

@objc protocol HXPHPickerControllerDelegate: NSObjectProtocol {
    
    /// 选择完成之后调用，单选模式下不会触发此回调
    /// - Parameters:
    ///   - pickerController: 对应的 HXPHPickerController
    ///   - selectedAssetArray: 选择的资源对应的 HXPHAsset 数据
    ///   - isOriginal: 是否选中的原图
    @objc optional func pickerController(_ pickerController: HXPHPickerController, didFinishWith selectedAssetArray: [HXPHAsset], _ isOriginal: Bool)
    
    /// 单选完成之后调用
    /// - Parameters:
    ///   - pickerController: 对应的 HXPHPickerController
    ///   - photoAsset: 对应的 HXPHAsset 数据
    ///   - isOriginal: 是否选中的原图
    @objc optional func pickerController(_ pickerController: HXPHPickerController, singleFinishWith photoAsset:HXPHAsset, _ isOriginal: Bool)
    
    /// 点击了原图按钮
    /// - Parameters:
    ///   - pickerController: 对应的 HXPHPickerController
    ///   - isOriginal: 是否选中的原图
    @objc optional func pickerController(_ pickerController: HXPHPickerController, didOriginalWith isOriginal: Bool)
    
    /// 是否能够选择cell 不能选择时需要自己手动弹出提示框
    /// - Parameters:
    ///   - pickerController: 对应的 HXPHPickerController
    ///   - photoAsset: 对应的 HXPHAsset 数据
    ///   - atIndex: 将要添加的索引
    @objc optional func pickerController(_ pickerController: HXPHPickerController, shouldSelectedAsset photoAsset: HXPHAsset, atIndex: Int) -> Bool

    /// 即将选择 cell 时调用
    @objc optional func pickerController(_ pickerController: HXPHPickerController, willSelectAsset photoAsset: HXPHAsset, atIndex: Int)

    /// 选择了 cell 之后调用
    @objc optional func pickerController(_ pickerController: HXPHPickerController, didSelectAsset photoAsset: HXPHAsset, atIndex: Int)

    /// 即将取消了选择 cell
    @objc optional func pickerController(_ pickerController: HXPHPickerController, willUnselectAsset photoAsset: HXPHAsset, atIndex: Int)

    /// 取消了选择 cell
    @objc optional func pickerController(_ pickerController: HXPHPickerController, didUnselectAsset photoAsset: HXPHAsset, atIndex: Int)
    
    /// 是否能够推出相机界面，点击相机cell时调用
    /// 可以跳转其他相机界面然后调用 addedCameraPhotoAsset
    @objc optional func pickerController(shouldPresentCamera pickerController: HXPHPickerController) -> Bool
    
    /// 预览界面更新当前显示的资源，collectionView滑动了就会调用
    /// - Parameters:
    ///   - pikcerController: 对应的 HXPHPickerController
    ///   - photoAsset: 对应显示的 HXPHAsset 数据
    ///   - index: 对应显示的位置
    @objc optional func pickerController(_ pikcerController: HXPHPickerController, previewUpdateCurrentlyDisplayedAsset photoAsset: HXPHAsset, atIndex: Int)
    
    /// 点击取消时调用
    /// - Parameter pickerController: 对应的 HXPHPickerController
    @objc optional func pickerController(didCancel pickerController: HXPHPickerController)
    
    /// dismiss后调用
    /// - Parameters:
    ///   - pickerController: 对应的 HXPHPickerController
    ///   - localCameraAssetArray: 相机拍摄存在本地的 HXPHAsset 数据
    ///     可以在下次进入选择时赋值给localCameraAssetArray，列表则会显示
    @objc optional func pickerController(_ pickerController: HXPHPickerController, didDismissWith localCameraAssetArray: [HXPHAsset])
    
    
    // MARK: 单独预览时的自定义转场动画
    /// present预览时展示的image
    /// - Parameters:
    ///   - pickerController: 对应的 HXPHPickerController
    ///   - index: 预览资源对应的位置
    @objc optional func pickerController(_ pickerController: HXPHPickerController, presentPreviewImageForIndexAt index: Int) -> UIImage?
    
    /// present 预览时起始的视图，用于获取位置大小。与 presentPreviewFrameForIndexAt 一样
    @objc optional func pickerController(_ pickerController: HXPHPickerController, presentPreviewViewForIndexAt index: Int) -> UIView?
    
    /// dismiss 结束时对应的视图，用于获取位置大小。与 dismissPreviewFrameForIndexAt 一样
    @objc optional func pickerController(_ pickerController: HXPHPickerController, dismissPreviewViewForIndexAt index: Int) -> UIView?
    
    /// present 预览时对应的起始位置大小
    @objc optional func pickerController(_ pickerController: HXPHPickerController, presentPreviewFrameForIndexAt index: Int) -> CGRect
    
    /// dismiss 结束时对应的位置大小
    @objc optional func pickerController(_ pickerController: HXPHPickerController, dismissPreviewFrameForIndexAt index: Int) -> CGRect
    
    /// 外部预览自定义 present 完成
    @objc optional func pickerController(_ pickerController: HXPHPickerController, previewPresentCompletion atIndex: Int)
    
    /// 外部预览自定义 dismiss 完成
    @objc optional func pickerController(_ pickerController: HXPHPickerController, previewDismissCompletion atIndex: Int)
}

class HXPHPickerController: UINavigationController, PHPhotoLibraryChangeObserver, UIViewControllerTransitioningDelegate {
    
    weak var pickerControllerDelegate : HXPHPickerControllerDelegate?
    
    /// 相关配置
    var config : HXPHConfiguration
    
    /// 当前被选择的资源对应的 HXPHAsset 对象数组
    /// 外部预览时的资源数据，可以设置previewIndex指定预览位置
    var selectedAssetArray: [HXPHAsset] = [] {
        didSet {
            configSelectedArray()
        }
    }
    
    /// 本地资源数组
    /// 创建本地资源的HXPHAsset然后赋值即可添加到照片列表，如需选中也要添加到selectedAssetArray中
    var localAssetArray: [HXPHAsset] = []
    
    /// 相机拍摄存在本地的资源数组
    /// 可以通过 pickerControllerDidDismiss 得到上一次相机拍摄的资源，然后赋值即可显示上一次相机拍摄的资源
    var localCameraAssetArray: [HXPHAsset] = []
    
    /// 是否选中了原图
    var isOriginal: Bool = false
    
    /// 刷新数据
    /// 可以在传入 selectedPhotoAssetArray 之后重新加载数据将重新设置的被选择的 HXPHAsset 选中
    /// - Parameter assetCollection: 切换显示其他资源集合
    public func reloadData(assetCollection: HXPHAssetCollection?) {
        pickerViewController()?.changedAssetCollection(collection: assetCollection)
        reloadAlbumData()
    }
    
    /// 使用其他相机拍摄完之后调用此方法添加
    /// - Parameter photoAsset: 对应的 HXPHAsset 数据
    public func addedCameraPhotoAsset(_ photoAsset: HXPHAsset) {
        hx_pickerController?.addedCameraPhotoAsset(photoAsset)
    }
    
    /// 所有资源集合
    private(set) var assetCollectionsArray : [HXPHAssetCollection] = []
    var fetchAssetCollectionsCompletion : (([HXPHAssetCollection])->())?
    
    /// 相机胶卷资源集合
    private(set) var cameraAssetCollection : HXPHAssetCollection?
    var fetchCameraAssetCollectionCompletion : ((HXPHAssetCollection?)->())?
    
    /// 外部预览时的下标
    var previewIndex: Int = 0 {
        didSet {
            if isPreviewAsset {
                previewViewController()?.currentPreviewIndex = previewIndex
            }
        }
    }
    
    /// 选择资源初始化
    /// - Parameter config: 相关配置
    convenience init(picker config: HXPHConfiguration) {
        self.init(config: config)
    }
    /// 选择资源初始化
    /// - Parameter config: 相关配置
    init(config: HXPHConfiguration) {
        HXPHManager.shared.appearanceStyle = config.appearanceStyle
        _ = HXPHManager.shared.createLanguageBundle(languageType: config.languageType)
        var photoVC : UIViewController
        if config.albumShowMode == .normal {
            photoVC = HXAlbumViewController.init()
        }else {
            photoVC = HXPHPickerViewController.init()
        }
        self.config = config
        if config.selectMode == .multiple &&
            !config.allowSelectedTogether &&
            config.maximumSelectedVideoCount == 1 &&
            config.selectType == .any {
            singleVideo = true
        }
        super.init(rootViewController: photoVC)
    }
    
    /// 外部预览资源初始化
    /// - Parameters:
    ///   - config: 相关配置
    ///   - modalPresentationStyle: 设置 custom 样式，框架自带动画效果
    init(preview config: HXPHConfiguration, modalPresentationStyle: UIModalPresentationStyle) {
        isPreviewAsset = true
        HXPHManager.shared.appearanceStyle = config.appearanceStyle
        _ = HXPHManager.shared.createLanguageBundle(languageType: config.languageType)
        self.config = config
        let vc = HXPHPreviewViewController.init()
        vc.isExternalPreview = true
        super.init(rootViewController: vc)
        self.modalPresentationStyle = modalPresentationStyle
        if modalPresentationStyle == .custom {
            transitioningDelegate = self
            modalPresentationCapturesStatusBarAppearance = true
        }
    }
    
    // MARK: 私有
    private var canAddAsset: Bool = true
    private var isFirstAuthorization: Bool = false
    private var selectType : HXPHPicker.SelectType?
    private var selectedPhotoAssetArray: [HXPHAsset] = []
    private var selectedVideoAssetArray: [HXPHAsset] = []
    private lazy var options : PHFetchOptions = {
        let options = PHFetchOptions.init()
        return options
    }()
    private lazy var deniedView: HXPHDeniedAuthorizationView = {
        let deniedView = HXPHDeniedAuthorizationView.init(config: config.notAuthorized)
        deniedView.frame = view.bounds
        return deniedView
    }()
    private var singleVideo: Bool = false
    private lazy var assetCollectionsQueue: OperationQueue = {
        let assetCollectionsQueue = OperationQueue.init()
        assetCollectionsQueue.maxConcurrentOperationCount = 1
        return assetCollectionsQueue
    }()
    private lazy var requestAssetBytesQueue: OperationQueue = {
        let requestAssetBytesQueue = OperationQueue.init()
        requestAssetBytesQueue.maxConcurrentOperationCount = 1
        return requestAssetBytesQueue
    }()
    private lazy var previewRequestAssetBytesQueue: OperationQueue = {
        let requestAssetBytesQueue = OperationQueue.init()
        requestAssetBytesQueue.maxConcurrentOperationCount = 1
        return requestAssetBytesQueue
    }()
    private var isPreviewAsset: Bool = false
    override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            if isPreviewAsset && modalPresentationStyle == .custom {
                transitioningDelegate = self
                modalPresentationCapturesStatusBarAppearance = true
            }
        }
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.config = HXPHConfiguration.init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setOptions() {
        if selectType == .photo {
            options.predicate = NSPredicate.init(format: "mediaType == %ld", argumentArray: [PHAssetMediaType.image.rawValue])
        }else if selectType == .video {
            options.predicate = NSPredicate.init(format: "mediaType == %ld", argumentArray: [PHAssetMediaType.video.rawValue])
        }else {
            options.predicate = nil
        }
    }
    private func configColor() {
        if config.appearanceStyle == .normal {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
            }
        }
        if modalPresentationStyle != .custom {
            configBackgroundColor()
        }
        let isDark = HXPHManager.shared.isDark
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : isDark ? config.navigationTitleDarkColor : config.navigationTitleColor]
        navigationBar.tintColor = isDark ? config.navigationDarkTintColor : config.navigationTintColor
        navigationBar.barStyle = isDark ? config.navigationBarDarkStyle : config.navigationBarStyle
    }
    func configBackgroundColor() {
        view.backgroundColor = HXPHManager.shared.isDark ? config.navigationViewBackgroudDarkColor : config.navigationViewBackgroundColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configColor()
        navigationBar.isTranslucent = config.navigationBarIsTranslucent
        selectType = config.selectType
        if !isPreviewAsset {
            setOptions()
            requestAuthorization()
        }
    }
    private func requestAuthorization() {
        if !config.allowLoadPhotoLibrary {
            fetchCameraAssetCollection()
            return
        }
        let status = HXPHAssetManager.authorizationStatus()
        if status.rawValue >= 3 {
            // 有权限
            fetchData(status: status)
        }else if status.rawValue >= 1 {
            // 无权限
            view.addSubview(deniedView)
        }else {
            // 用户还没做出选择，请求权限
            isFirstAuthorization = true
            HXPHAssetManager.requestAuthorization { (status) in
                self.fetchData(status: status)
                self.albumViewController()?.updatePrompt()
                self.pickerViewController()?.reloadAlbumData()
                self.pickerViewController()?.updateBottomPromptView()
            }
        }
    }
    private func fetchData(status: PHAuthorizationStatus) {
        if status.rawValue >= 3 {
            PHPhotoLibrary.shared().register(self)
            // 有权限
            HXPHProgressHUD.showLoadingHUD(addedTo: view, afterDelay: 0.15, animated: true)
            fetchCameraAssetCollection()
        }else if status.rawValue >= 1 {
            // 无权限
            view.addSubview(deniedView)
        }
    }
    // MARK: 暴露给子控制器的方法
    func finishCallback() {
        pickerControllerDelegate?.pickerController?(self, didFinishWith: selectedAssetArray, isOriginal)
        dismiss(animated: true, completion: nil)
    }
    func singleFinishCallback(for photoAsset: HXPHAsset) {
        pickerControllerDelegate?.pickerController?(self, singleFinishWith: photoAsset, isOriginal)
        dismiss(animated: true, completion: nil)
    }
    func cancelCallback() {
        pickerControllerDelegate?.pickerController?(didCancel: self)
        dismiss(animated: true, completion: nil)
    }
    func originalButtonCallback() {
        pickerControllerDelegate?.pickerController?(self, didOriginalWith: isOriginal)
    }
    func shouldPresentCamera() -> Bool {
        if let shouldPresent = pickerControllerDelegate?.pickerController?(shouldPresentCamera: self) {
            return shouldPresent
        }
        return true
    }
    func previewUpdateCurrentlyDisplayedAsset(photoAsset: HXPHAsset, index: Int) {
        pickerControllerDelegate?.pickerController?(self, previewUpdateCurrentlyDisplayedAsset: photoAsset, atIndex: index)
    }
    
    /// 获取已选资源的总大小
    /// - Parameters:
    ///   - isPreview: 是否是预览界面获取
    ///   - completion: 完成回调
    func requestSelectedAssetFileSize(isPreview: Bool, completion: @escaping (Int, String) -> Void) {
        cancelRequestAssetFileSize(isPreview: isPreview)
        let operation = BlockOperation.init {
            var totalFileSize = 0
            for photoAsset in self.selectedAssetArray {
                totalFileSize += photoAsset.fileSize
            }
            if isPreview {
                if let operation =
                    self.previewRequestAssetBytesQueue.operations.first {
                    if operation.isCancelled {
                        return
                    }
                }
            }else {
                if let operation =
                    self.requestAssetBytesQueue.operations.first {
                    if operation.isCancelled {
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                completion(totalFileSize, HXPHTools.transformBytesToString(bytes: totalFileSize))
            }
        }
        if isPreview {
            previewRequestAssetBytesQueue.addOperation(operation)
        }else {
            requestAssetBytesQueue.addOperation(operation)
        }
    }
    
    /// 取消获取资源文件大小
    /// - Parameter isPreview: 是否预览界面
    func cancelRequestAssetFileSize(isPreview: Bool) {
        if isPreview {
            previewRequestAssetBytesQueue.cancelAllOperations()
        }else {
            requestAssetBytesQueue.cancelAllOperations()
        }
    }
    
    /// 更新相册资源
    /// - Parameters:
    ///   - coverImage: 封面图片
    ///   - count: 需要累加的数量
    func updateAlbums(coverImage: UIImage?, count: Int) {
        for assetCollection in assetCollectionsArray {
            if assetCollection.realCoverImage != nil {
                assetCollection.realCoverImage = coverImage
            }
            assetCollection.count += count
        }
        reloadAlbumData()
    }
    /// 获取相机胶卷资源集合
    func fetchCameraAssetCollection() {
        if !config.allowLoadPhotoLibrary {
            if cameraAssetCollection == nil {
                cameraAssetCollection = HXPHAssetCollection.init(albumName: config.albumList.emptyAlbumName.hx_localized, coverImage: config.albumList.emptyCoverImageName.hx_image)
            }
            fetchCameraAssetCollectionCompletion?(cameraAssetCollection)
            return
        }
        if config.creationDate {
            options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: config.creationDate)]
        }
        HXPHManager.shared.fetchCameraAssetCollection(for: selectType ?? .any, options: options) { (assetCollection) in
            if assetCollection.count == 0 {
                self.cameraAssetCollection = HXPHAssetCollection.init(albumName: self.config.albumList.emptyAlbumName.hx_localized, coverImage: self.config.albumList.emptyCoverImageName.hx_image)
            }else {
                // 获取封面
                assetCollection.fetchCoverAsset()
                self.cameraAssetCollection = assetCollection
            }
            if self.config.albumShowMode == .popup {
                self.fetchAssetCollections()
            }
            self.fetchCameraAssetCollectionCompletion?(self.cameraAssetCollection)
        }
    }
    
    /// 获取相册集合
    func fetchAssetCollections() {
        assetCollectionsQueue.cancelAllOperations()
        let operation = BlockOperation.init {
            if self.config.creationDate {
                self.options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: self.config.creationDate)]
            }
            self.assetCollectionsArray = []
            
            var localCount = self.localAssetArray.count + self.localCameraAssetArray.count
            var coverImage = self.localCameraAssetArray.first?.originalImage
            if coverImage == nil {
                coverImage = self.localAssetArray.first?.originalImage
            }
            var firstSetImage = true
            for phAsset in self.selectedAssetArray {
                if phAsset.asset == nil {
                    let inLocal = self.localAssetArray.contains(where: { (localAsset) -> Bool in
                        return localAsset.isEqual(phAsset)
                    })
                    let inLocalCamera = self.localCameraAssetArray.contains(where: { (localAsset) -> Bool in
                        return localAsset.isEqual(phAsset)
                    })
                    if !inLocal && !inLocalCamera {
                        if firstSetImage {
                            coverImage = phAsset.originalImage
                            firstSetImage = false
                        }
                        localCount += 1
                    }
                }
            }
            if !self.config.allowLoadPhotoLibrary {
                DispatchQueue.main.async {
                    self.cameraAssetCollection?.realCoverImage = coverImage
                    self.cameraAssetCollection?.count += localCount
                    self.assetCollectionsArray.append(self.cameraAssetCollection!)
                    self.fetchAssetCollectionsCompletion?(self.assetCollectionsArray)
                }
                return
            }
            HXPHManager.shared.fetchAssetCollections(for: self.options, showEmptyCollection: false) { (assetCollection, isCameraRoll) in
                if assetCollection != nil {
                    // 获取封面
                    assetCollection?.fetchCoverAsset()
                    assetCollection?.count += localCount
                    if isCameraRoll {
                        self.assetCollectionsArray.insert(assetCollection!, at: 0);
                    }else {
                        self.assetCollectionsArray.append(assetCollection!)
                    }
                }else {
                    if self.cameraAssetCollection != nil {
                        self.cameraAssetCollection?.count += localCount
                        if coverImage != nil {
                            self.cameraAssetCollection?.realCoverImage = coverImage
                        }
                        if !self.assetCollectionsArray.isEmpty {
                            self.assetCollectionsArray[0] = self.cameraAssetCollection!
                        }else {
                            self.assetCollectionsArray.append(self.cameraAssetCollection!)
                        }
                    }
                    DispatchQueue.main.async {
                        if let operation =
                            self.assetCollectionsQueue.operations.first {
                            if operation.isCancelled {
                                return
                            }
                        }
                        self.fetchAssetCollectionsCompletion?(self.assetCollectionsArray)
                    }
                }
            }
        }
        assetCollectionsQueue.addOperation(operation)
    }
    /// 获取相册里的资源
    /// - Parameters:
    ///   - assetCollection: 相册
    ///   - completion: 完成回调
    func fetchPhotoAssets(assetCollection: HXPHAssetCollection?, completion: @escaping ([HXPHAsset], HXPHAsset?) -> Void) {
        DispatchQueue.global().async {
            var selectedAssets = [PHAsset]()
            var selectedPhotoAssets:[HXPHAsset] = []
            var localAssets: [HXPHAsset] = []
            var localIndex = -1
            for (index, phAsset) in self.selectedAssetArray.enumerated() {
                phAsset.selectIndex = index
                if phAsset.asset != nil {
                    selectedAssets.append(phAsset.asset!)
                    selectedPhotoAssets.append(phAsset)
                }else {
                    let inLocal = self.localAssetArray.contains { (localAsset) -> Bool in
                        if localAsset.isEqual(phAsset) {
                            self.localAssetArray[self.localAssetArray.firstIndex(of: localAsset)!] = phAsset
                            return true
                        }
                        return false
                    }
                    let inLocalCamera = self.localCameraAssetArray.contains(where: { (localAsset) -> Bool in
                        if localAsset.isEqual(phAsset) {
                            self.localCameraAssetArray[self.localCameraAssetArray.firstIndex(of: localAsset)!] = phAsset
                            return true
                        }
                        return false
                    })
                    if !inLocal && !inLocalCamera {
                        if phAsset.localIndex > localIndex  {
                            localIndex = phAsset.localIndex
                            self.localAssetArray.insert(phAsset, at: 0)
                        }else {
                            if localIndex == -1 {
                                localIndex = phAsset.localIndex
                                self.localAssetArray.insert(phAsset, at: 0)
                            }else {
                                self.localAssetArray.insert(phAsset, at: 1)
                            }
                        }
                    }
                }
            }
            localAssets.append(contentsOf: self.localCameraAssetArray.reversed())
            localAssets.append(contentsOf: self.localAssetArray)
            var photoAssets = [HXPHAsset]()
            photoAssets.reserveCapacity(assetCollection?.count ?? 0)
            var lastAsset: HXPHAsset?
            assetCollection?.enumerateAssets(usingBlock: { (photoAsset) in
                if photoAsset.mediaType == .photo {
                    if self.selectType == .video {
                        return
                    }
                    if self.config.showImageAnimated == true {
                        if HXPHAssetManager.assetIsAnimated(asset: photoAsset.asset!) {
                            photoAsset.mediaSubType = .imageAnimated
                        }
                    }
                    if self.config.showLivePhoto == true {
                        if HXPHAssetManager.assetIsLivePhoto(asset: photoAsset.asset!) {
                            photoAsset.mediaSubType = .livePhoto
                        }
                    }
                }else if photoAsset.mediaType == .video {
                    if self.selectType == .photo {
                        return
                    }
                }
                var asset = photoAsset
                if selectedAssets.contains(asset.asset!) {
                    let index = selectedAssets.firstIndex(of: asset.asset!)!
                    let phAsset: HXPHAsset = selectedPhotoAssets[index]
                    asset = phAsset
                    lastAsset = phAsset
                }
                if self.config.reverseOrder == true {
                    photoAssets.insert(asset, at: 0)
                }else {
                    photoAssets.append(asset)
                }
            })
            if self.config.reverseOrder == true {
                photoAssets.insert(contentsOf: localAssets, at: 0)
            }else {
                photoAssets.append(contentsOf: localAssets.reversed())
            }
            DispatchQueue.main.async {
                completion(photoAssets, lastAsset)
            }
        }
    }
    func addedLocalCameraAsset(photoAsset: HXPHAsset) {
        photoAsset.localIndex = localCameraAssetArray.count
        localCameraAssetArray.append(photoAsset)
    }
    func addedPhotoAsset(photoAsset: HXPHAsset) -> Bool {
        if singleVideo && photoAsset.mediaType == .video {
            return false
        }
        if config.selectMode == .single {
            // 单选模式不可添加
            return false
        }
        let canSelect = canSelectAsset(for: photoAsset, showHUD: true)
        if canSelect {
            pickerControllerDelegate?.pickerController?(self, willSelectAsset: photoAsset, atIndex: selectedAssetArray.count)
            canAddAsset = false
            photoAsset.isSelected = true
            photoAsset.selectIndex = selectedAssetArray.count
            if photoAsset.mediaType == .photo {
                selectedPhotoAssetArray.append(photoAsset)
            }else if photoAsset.mediaType == .video {
                selectedVideoAssetArray.append(photoAsset)
            }
            selectedAssetArray.append(photoAsset)
            pickerControllerDelegate?.pickerController?(self, didSelectAsset: photoAsset, atIndex: selectedAssetArray.count - 1)
        }
        return canSelect
    }
    func removePhotoAsset(photoAsset: HXPHAsset) -> Bool {
        if selectedAssetArray.isEmpty {
            return false
        }
        canAddAsset = false
        pickerControllerDelegate?.pickerController?(self, willUnselectAsset: photoAsset, atIndex: selectedAssetArray.count)
        photoAsset.isSelected = false
        if photoAsset.mediaType == .photo {
            selectedPhotoAssetArray.remove(at: selectedPhotoAssetArray.firstIndex(of: photoAsset)!)
        }else if photoAsset.mediaType == .video {
            selectedVideoAssetArray.remove(at: selectedVideoAssetArray.firstIndex(of: photoAsset)!)
        }
        selectedAssetArray.remove(at: selectedAssetArray.firstIndex(of: photoAsset)!)
        for (index, asset) in selectedAssetArray.enumerated() {
            asset.selectIndex = index
        }
        pickerControllerDelegate?.pickerController?(self, didUnselectAsset: photoAsset, atIndex: selectedAssetArray.count)
        return true
    }
    func canSelectAsset(for photoAsset: HXPHAsset, showHUD: Bool) -> Bool {
        var canSelect = true
        var text: String?
        if photoAsset.mediaType == .photo {
            if config.maximumSelectedPhotoFileSize > 0 {
                if photoAsset.fileSize > config.maximumSelectedPhotoFileSize {
                    text = "照片大小超过最大限制".hx_localized + HXPHTools.transformBytesToString(bytes: config.maximumSelectedPhotoFileSize)
                    canSelect = false
                }
            }
            if !config.allowSelectedTogether {
                if selectedVideoAssetArray.count > 0 {
                    text = "照片和视频不能同时选择".hx_localized
                    canSelect = false
                }
            }
            if config.maximumSelectedPhotoCount > 0 {
                if selectedPhotoAssetArray.count >= config.maximumSelectedPhotoCount {
                    text = String.init(format: "最多只能选择%d张照片".hx_localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }else {
                if selectedAssetArray.count >= config.maximumSelectedCount && config.maximumSelectedCount > 0 {
                    text = String.init(format: "已达到最大选择数".hx_localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }
        }else if photoAsset.mediaType == .video {
            if config.maximumSelectedVideoFileSize > 0 {
                if photoAsset.fileSize > config.maximumSelectedVideoFileSize {
                    text = "视频大小超过最大限制".hx_localized + HXPHTools.transformBytesToString(bytes: config.maximumSelectedVideoFileSize)
                    canSelect = false
                }
            }
            if config.maximumSelectedVideoDuration > 0 {
                if round(photoAsset.videoDuration) > Double(config.maximumSelectedVideoDuration) {
                    text = String.init(format: "视频最大时长为%d秒，无法选择".hx_localized, arguments: [config.maximumSelectedVideoDuration])
                    canSelect = false
                }
            }
            if config.minimumSelectedVideoDuration > 0 {
                if photoAsset.videoDuration < Double(config.minimumSelectedVideoDuration) {
                    text = String.init(format: "视频最小时长为%d秒，无法选择".hx_localized, arguments: [config.minimumSelectedVideoDuration])
                    canSelect = false
                }
            }
            if !config.allowSelectedTogether {
                if selectedPhotoAssetArray.count > 0 {
                    text = "视频和照片不能同时选择".hx_localized
                    canSelect = false
                }
            }
            if config.maximumSelectedVideoCount > 0 {
                if selectedVideoAssetArray.count >= config.maximumSelectedVideoCount {
                    text = String.init(format: "最多只能选择%d个视频".hx_localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }else {
                if selectedAssetArray.count >= config.maximumSelectedCount && config.maximumSelectedCount > 0 {
                    text = String.init(format: "已达到最大选择数".hx_localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }
        }
        if let shouldSelect = pickerControllerDelegate?.pickerController?(self, shouldSelectedAsset: photoAsset, atIndex: selectedAssetArray.count) {
            if canSelect {
                canSelect = shouldSelect
            }
        }
        if !canSelect && text != nil && showHUD {
            HXPHProgressHUD.showWarningHUD(addedTo: view, text: text!, animated: true, delay: 2)
        }
        return canSelect
    }
    private func configSelectedArray() {
        if isPreviewAsset {
            previewViewController()?.previewAssets = selectedAssetArray
            return
        }
        if config.selectMode == .single {
            return
        }
        if !canAddAsset {
            canAddAsset = true
            return
        }
        for photoAsset in selectedAssetArray {
            photoAsset.isSelected = true
            if photoAsset.mediaType == .photo {
                selectedPhotoAssetArray.append(photoAsset)
            }else if photoAsset.mediaType == .video {
                if singleVideo {
                    selectedAssetArray.remove(at: selectedAssetArray.firstIndex(of: photoAsset)!)
                }else {
                    selectedVideoAssetArray.append(photoAsset)
                }
            }
        }
    }
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if isFirstAuthorization && viewControllerToPresent is UIImagePickerController {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
            isFirstAuthorization = false
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if presentingViewController == nil {
            // 为空说明dismiss了
            var cameraAssetArray: [HXPHAsset] = []
            for photoAsset in localCameraAssetArray {
                cameraAssetArray.append(photoAsset.copyCamera())
            }
            pickerControllerDelegate?.pickerController?(self, didDismissWith: cameraAssetArray)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let status = HXPHAssetManager.authorizationStatus()
        if status.rawValue >= 1 && status.rawValue < 3 {
            deniedView.frame = view.bounds
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return config.statusBarStyle
    }
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? UIStatusBarAnimation.fade
    }
    
    // MARK: PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if !HXPHAssetManager.authorizationStatusIsLimited() || !config.allowLoadPhotoLibrary {
            return
        }
        var needReload = false
        if assetCollectionsArray.isEmpty {
            if cameraAssetCollection != nil {
                needReload = resultHasChanges(for: changeInstance, assetCollection: cameraAssetCollection!)
            }else {
                needReload = true
            }
        }else {
            let collectionArray = assetCollectionsArray
            for assetCollection in collectionArray {
                let hasChanges = resultHasChanges(for: changeInstance, assetCollection: assetCollection)
                if !needReload {
                    needReload = hasChanges;
                }
            }
        }
        if needReload {
            DispatchQueue.main.async {
                if self.cameraAssetCollection?.result == nil {
                    self.fetchCameraAssetCollection()
                }else {
                    self.reloadData(assetCollection: nil)
                }
                self.fetchAssetCollections()
            }
        }
    }
    private func resultHasChanges(for changeInstance:PHChange, assetCollection: HXPHAssetCollection) -> Bool {
        if assetCollection.result == nil {
            if assetCollection == self.cameraAssetCollection {
                return true
            }
            return false
        }
        let changeResult : PHFetchResultChangeDetails? = changeInstance.changeDetails(for: assetCollection.result!)
        if changeResult != nil {
            if !changeResult!.hasIncrementalChanges {
                let result = changeResult!.fetchResultAfterChanges
                assetCollection.changeResult(for: result)
                if assetCollection == self.cameraAssetCollection && result.count == 0 {
                    assetCollection.change(albumName: self.config.albumList.emptyAlbumName.hx_localized, coverImage: self.config.albumList.emptyCoverImageName.hx_image)
                    assetCollection.count = 0
                    assetCollection.coverAsset = nil
                }else {
                    assetCollection.fetchCoverAsset()
                }
                return true
            }
        }
        return false
    }
    private func reloadAlbumData() {
        albumViewController()?.tableView.reloadData()
    }
    func albumViewController() -> HXAlbumViewController? {
        return getViewController(for: HXAlbumViewController.self) as? HXAlbumViewController
    }
    func pickerViewController() -> HXPHPickerViewController? {
        return getViewController(for: HXPHPickerViewController.self) as? HXPHPickerViewController
    }
    func previewViewController() -> HXPHPreviewViewController? {
        return getViewController(for: HXPHPreviewViewController.self) as? HXPHPreviewViewController
    }
    private func getViewController(for viewControllerClass: UIViewController.Type) -> UIViewController? {
        for viewController in viewControllers {
            if viewController.isMember(of: viewControllerClass) {
                return viewController
            }
        }
        return nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                configColor()
            }
        }
    }
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HXPHPickerControllerTransition.init(type: .present)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HXPHPickerControllerTransition.init(type: .dismiss)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        print("\(self) deinit")
    }
}

class HXPHDeniedAuthorizationView: UIView {
    
    var config: HXPHNotAuthorizedConfiguration?
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar.init()
        navigationBar.setBackgroundImage(UIImage.hx_image(for: UIColor.clear, havingSize: CGSize.zero), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage.init()
        let navigationItem = UINavigationItem.init()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: closeBtn)
        navigationBar.pushItem(navigationItem, animated: false)
        return navigationBar
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton.init(type: .custom)
        closeBtn.hx_size = CGSize(width: 50, height: 40)
        closeBtn.addTarget(self, action: #selector(didCloseClick), for: .touchUpInside)
        closeBtn.contentHorizontalAlignment = .left
        return closeBtn
    }()
    
    lazy var titleLb: UILabel = {
        let titleLb = UILabel.init()
        titleLb.textAlignment = .center
        titleLb.numberOfLines = 0
        return titleLb
    }()
    
    lazy var subTitleLb: UILabel = {
        let subTitleLb = UILabel.init()
        subTitleLb.textAlignment = .center
        subTitleLb.numberOfLines = 0
        return subTitleLb
    }()
    
    lazy var jumpBtn: UIButton = {
        let jumpBtn = UIButton.init(type: .custom)
        jumpBtn.layer.cornerRadius = 5
        jumpBtn.addTarget(self, action: #selector(jumpSetting), for: .touchUpInside)
        return jumpBtn
    }()
    
    init(config: HXPHNotAuthorizedConfiguration?) {
        super.init(frame: CGRect.zero)
        self.config = config
        configView()
    }
    
    func configView() {
        addSubview(navigationBar)
        addSubview(titleLb)
        addSubview(subTitleLb)
        addSubview(jumpBtn)
        
        titleLb.text = "无法访问相册中照片".hx_localized
        titleLb.font = UIFont.hx_semiboldPingFang(size: 20)
        
        subTitleLb.text = "当前无照片访问权限，建议前往系统设置，\n允许访问「照片」中的「所有照片」。".hx_localized
        subTitleLb.font = UIFont.hx_regularPingFang(size: 17)
        
        jumpBtn.setTitle("前往系统设置".hx_localized, for: .normal)
        jumpBtn.titleLabel?.font = UIFont.hx_mediumPingFang(size: 16)
        
        configColor()
    }
    func configColor() {
        let closeButtonImageName = config?.closeButtonImageName ?? "hx_picker_notAuthorized_close"
        let closeButtonDarkImageName = config?.closeButtonDarkImageName ?? "hx_picker_notAuthorized_close_dark"
        let isDark = HXPHManager.shared.isDark
        closeBtn.setImage(UIImage.hx_named(named: isDark ? closeButtonDarkImageName : closeButtonImageName), for: .normal)
        backgroundColor = isDark ? config?.darkBackgroundColor : config?.backgroundColor
        titleLb.textColor = isDark ? config?.titleDarkColor : config?.titleColor
        subTitleLb.textColor = isDark ? config?.darkSubTitleColor : config?.subTitleColor
        jumpBtn.backgroundColor = isDark ? config?.jumpButtonDarkBackgroundColor : config?.jumpButtonBackgroundColor
        jumpBtn.setTitleColor(isDark ? config?.jumpButtonTitleDarkColor : config?.jumpButtonTitleColor, for: .normal)
    }
    @objc func didCloseClick() {
        self.hx_viewController()?.dismiss(animated: true, completion: nil)
    }
    @objc func jumpSetting() {
        HXPHTools.openSettingsURL()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var barHeight: CGFloat = 0
        if hx_viewController()?.navigationController?.modalPresentationStyle == UIModalPresentationStyle.fullScreen {
            barHeight = (hx_viewController()?.navigationController?.navigationBar.hx_height ?? 44) + UIDevice.current.hx_statusBarHeight
        }else {
            barHeight = hx_viewController()?.navigationController?.navigationBar.hx_height ?? 44
        }
        navigationBar.frame = CGRect(x: 0, y: 0, width: hx_width, height: barHeight)
        
        let titleHeight = titleLb.text?.hx_stringHeight(ofFont: titleLb.font, maxWidth: hx_width) ?? 0
        titleLb.frame = CGRect(x: 0, y: 0, width: hx_width, height: titleHeight)
        
        let subTitleHeight = subTitleLb.text?.hx_stringHeight(ofFont: subTitleLb.font, maxWidth: hx_width - 40) ?? 0
        subTitleLb.frame = CGRect(x: 20, y: hx_height / 2 - subTitleHeight - 30 - UIDevice.current.hx_topMargin, width: hx_width - 40, height: subTitleHeight)
        titleLb.hx_y = subTitleLb.hx_y - 15 - titleHeight
        
        let jumpBtnBottomMargin : CGFloat = UIDevice.isProxy() ? 120 : 50
        var jumpBtnWidth = (jumpBtn.currentTitle?.hx_stringWidth(ofFont: jumpBtn.titleLabel!.font, maxHeight: 40) ?? 0 ) + 10
        if jumpBtnWidth < 150 {
            jumpBtnWidth = 150
        }
        jumpBtn.frame = CGRect(x: 0, y: hx_height - UIDevice.current.hx_bottomMargin - 40 - jumpBtnBottomMargin, width: jumpBtnWidth, height: 40)
        jumpBtn.hx_centerX = hx_width * 0.5
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                configColor()
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HXPHEmptyView: UIView {
    lazy var titleLb: UILabel = {
        let titleLb = UILabel.init()
        titleLb.text = "没有照片".hx_localized
        titleLb.numberOfLines = 0
        titleLb.textAlignment = .center
        titleLb.font = UIFont.hx_semiboldPingFang(size: 20)
        return titleLb
    }()
    lazy var subTitleLb: UILabel = {
        let subTitleLb = UILabel.init()
        subTitleLb.text = "你可以使用相机拍些照片".hx_localized
        subTitleLb.numberOfLines = 0
        subTitleLb.textAlignment = .center
        subTitleLb.font = UIFont.hx_mediumPingFang(size: 16)
        return subTitleLb
    }()
    var config: HXPHEmptyViewConfiguration? {
        didSet {
            configColor()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLb)
        addSubview(subTitleLb)
    }
    
    func configColor() {
        titleLb.textColor = HXPHManager.shared.isDark ? config?.titleDarkColor : config?.titleColor
        subTitleLb.textColor = HXPHManager.shared.isDark ? config?.subTitleDarkColor : config?.subTitleColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleHeight = titleLb.text?.hx_stringHeight(ofFont: titleLb.font, maxWidth: hx_width - 20) ?? 0
        titleLb.frame = CGRect(x: 10, y: 0, width: hx_width - 20, height: titleHeight)
        let subTitleHeight = titleLb.text?.hx_stringHeight(ofFont: subTitleLb.font, maxWidth: hx_width - 20) ?? 0
        subTitleLb.frame = CGRect(x: 10, y: titleLb.frame.maxY + 3, width: hx_width - 20, height: subTitleHeight)
        hx_height = subTitleLb.frame.maxY
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                configColor()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
