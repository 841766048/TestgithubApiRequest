//
//  RequestGithubApiVC.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import UIKit

struct MyTableSection {
    ///定义分区的区头文字
    var header:String
    /// 定义分区的数据源
    var items:[Dictionary<String,String>]
}

extension MyTableSection : SectionModelType {
    typealias Item = Dictionary<String,String>
    init(original: MyTableSection, items: [Dictionary<String,String>]) {
        self = original
        self.items = items
    }
}


class RequestGithubApiVC: BaseViewController {
    
    let disposeBag = DisposeBag()
    let dataRequest = PublishSubject<Void>()
    let viewModel = RequestGithubApiViewModel()
    var dataSource:RxTableViewSectionedReloadDataSource<MyTableSection>?
    /// 懒加载tableview
    lazy var tableView :UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style:.grouped)
        tableView.bounces = false
        tableView.rowHeight = 44.auto()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0.01))
        tableView.register(UINib(nibName: "RequestGithubCell", bundle: nil), forCellReuseIdentifier: "RequestGithubCell")
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.01))
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.title = "主页"
        customNavBar.wr_setRightButtonWithImage(normalImage:UIImage(named: "lishijilu"))
        setUI()
        bindViewMode()
        //定时器（5秒执行一次）
        Observable<Int>.interval(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.dataRequest.onNext(())
                NSLog("请求")
            }).disposed(by: disposeBag)
        
    }
    
}

extension RequestGithubApiVC {
    
    func setUI(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.customNavBar.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        customNavBar.onClickRightButton = { [unowned self] in
            self.navigationController?.pushViewController(RequestGithubApiHistoryVC(), animated: true)
        }
    }
    
    func bindViewMode() {
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MyTableSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestGithubCell", for: indexPath) as! RequestGithubCell
            //            cell.selectionStyle = .none
            let dict = dataSource[indexPath]
            cell.titleLabel.text = dict["title"]
            cell.contentLabel.text = dict["value"]
            return cell
        })
        self.dataSource = dataSource
        
        // 初始化输入信号源
        let input = RequestGithubApiViewModel.Input(dataRequest: dataRequest)
        
        let output = viewModel.transform(input)
        //绑定单元格数据
        output.result.skip(1)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected,tableView.rx.modelSelected(Dictionary<String,String>.self))
            .bind{ [unowned self] indexPath, item in
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                let past = UIPasteboard.general
                past.string = item["value"]
                NSObject().appearController()?.showHUD(title: "复制成功")
                
            }.disposed(by: disposeBag)
        
        //设置代理
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}

extension RequestGithubApiVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
