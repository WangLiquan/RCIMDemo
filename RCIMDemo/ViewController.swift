//
//  ViewController.swift
//  RCIMDemo
//
//  Created by Ethan.Wang on 2018/9/21.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit
///示例数据,正常应该从后台获取.
let personArray = ["jame","ethan","wang","bridge","gai"]

///这里使用的是自己实现的通讯录列表,根据需求可以选择使用融云自带的通讯列表页面,新建自己的viewController继承自RCConversationListViewController
class ViewController: UIViewController {

    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        
//        tableView.separatorStyle = .none
        tableView.isOpaque = false
        tableView.dataSource = self
        tableView.delegate = self
        /// reloadData后contentOffset更改,导致布局效果问题 添加三行
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0

        tableView.showsHorizontalScrollIndicator=true;
        tableView.showsVerticalScrollIndicator=false;
        tableView.register(EWChatListTableViewCell.self, forCellReuseIdentifier: EWChatListTableViewCell.identifier)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name:   Notification.Name(rawValue: "onRCIMReceive"), object: nil)
    }
    /// 融云通知获取信息时调用刷新群组信息数
    @objc private func reloadData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "onRCIMReceive"), object: nil)
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EWChatListTableViewCell.identifier) as? EWChatListTableViewCell else {
            return EWChatListTableViewCell()
        }
        /** 这里的badge应该是从userDefault中获取.我在融云控制台注册了userID[0,1,2,3,4].并使用控制台给登录的userID"123456"发送消息.
            正常接入时userID也是后台传给融云的,可以通过后台获取.
        */

        let dic = getMessageDic(PERSONMESSAGEKEY)
        let num = dic["\(indexPath.row)"]
        cell.setData(name: personArray[indexPath.row], badge: num ?? 0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /// targetID就是目标用户的targetID,是后台传给融云的,我们也是从后台获取
        let chat = EWPersonChatViewController(conversationType: .ConversationType_PRIVATE, targetId: "\(indexPath.row)")
        self.navigationController?.pushViewController(chat!, animated: true)
        var dic = getMessageDic(PERSONMESSAGEKEY)
        dic.removeValue(forKey: "\(indexPath.row)")
        UserDefaults.standard.set(dic, forKey: PERSONMESSAGEKEY)
        self.reloadData()
    }
}

