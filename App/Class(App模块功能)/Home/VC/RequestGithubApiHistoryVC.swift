//
//  RequestGithubApiHistoryVC.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import UIKit

class RequestGithubApiHistoryVC: BaseViewController {
    let disposeBag = DisposeBag()
    let viewModel = RequestGithubApiHistoryViewModel()
    
    var dataSource:[MyTableSection]?
    
    var selectSection:Int = 0
    
    /// 懒加载tableview
    lazy var tableView :UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style:.plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44.auto()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0.01))
        tableView.register(UINib(nibName: "RequestGithubCell", bundle: nil), forCellReuseIdentifier: "RequestGithubCell")
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.01))
        //设置头部刷新控件
        tableView.mj_header = MJRefreshNormalHeader()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.title = "历史记录"
        customNavBar.bottomLineHidden = false
        // 创建表
        SQLiteManager.shareManger().createTable()
        setUI()
        bindViewMode()
        tableView.mj_header?.beginRefreshing()
    }
    

}
extension RequestGithubApiHistoryVC {
    
    func setUI(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.customNavBar.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func bindViewMode() {
        
        // 初始化输入信号源
        let input = RequestGithubApiHistoryViewModel.Input(headerRefresh: self.tableView.mj_header!.rx.refreshing.asObservable())
        
        let output = viewModel.transform(input)
        
        //下拉刷新状态结束的绑定
        output.endHeaderRefreshing
            .drive(tableView.mj_header!.rx.isRefreshing)
            .disposed(by: disposeBag)
                      
        output.result.map { $0 }
            .asObservable().subscribe {[weak self] (event) in
                self?.dataSource = event.element
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)

    }
    
}

extension RequestGithubApiHistoryVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        guard let dataSource = self.dataSource else {
            return
        }
        let past = UIPasteboard.general
        past.string = dataSource[indexPath.section].items[indexPath.row]["value"]
        NSObject().appearController()?.showHUD(title: "复制成功")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //返回分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50.auto()))
        headerView.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50.auto()))
        button.tag = section
        button.addTarget(self, action: #selector(sectionClick(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        headerView.addSubview(button)
       
        
        headerView.addBottomBorder(borderWidth: 1, borderCorlor: kHexColor(rgb: 0xEEEEEE))
        
        guard let dataSource = self.dataSource else {
            return headerView
        }
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.text = dataSource[section].header
        titleLabel.textColor = section == 0 ? .red : UIColor.black
        titleLabel.font = kBoldFont(size: 15)
        titleLabel.frame = CGRect(x: 15.auto(), y: 0, width: kScreenWidth - 2*15.auto(), height: 50.auto())
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    // 返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.auto()
    }
}

extension RequestGithubApiHistoryVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        if section == selectSection {
            return dataSource[section].items.count
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestGithubCell", for: indexPath) as! RequestGithubCell
        cell.backgroundColor = .clear
        if let dict = self.dataSource?[indexPath.section].items[indexPath.row]  {
            cell.titleLabel.text = dict["title"]
            cell.contentLabel.text = dict["value"]
        }
        return cell
    }
    
    
}

extension RequestGithubApiHistoryVC{
    //按钮实现的方法
    @objc func sectionClick(_ button:UIButton){
        if selectSection == button.tag {
            selectSection = -1
        }else{
            selectSection = button.tag
        }
//        let indexPath: IndexPath = IndexPath.init(row: 0, section:  button.tag)
        self.tableView.reloadSections(IndexSet(integersIn: 0...button.tag), with: .fade)
    }
}
