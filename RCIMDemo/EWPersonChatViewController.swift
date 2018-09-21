//
//  EWPersonChatViewController.swift
//  RCIMDemo
//
//  Created by Ethan.Wang on 2018/9/21.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit
///因为我们的appkey,targetID都是错误的,所以无法聊天,正常app流程下不会出现这种问题.
class EWPersonChatViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "聊天页"

        ///如果需要修改页面样式,可以修改self.conversationMessageCollectionView属性
        self.conversationMessageCollectionView.backgroundColor = UIColor.brown
        
        addPhoneButton()

        // Do any additional setup after loading the view.
    }
    /// 添加聊天页加号按钮中的功能
    func addPhoneButton(){
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "PersonChatVC_phone"), title: "拨打电话", tag: 4)
    }
    /// 实现添加的按钮功能
    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        if tag == 4{
            let str = "telprompt://" + ("18511111111")
            UIApplication.shared.open(URL(string: str)!, options: ["":""], completionHandler: nil)
        }
    }


}
