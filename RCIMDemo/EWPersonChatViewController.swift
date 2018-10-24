//
//  EWPersonChatViewController.swift
//  RCIMDemo
//
//  Created by Ethan.Wang on 2018/9/21.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class EWPersonChatViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "聊天页"

//        ///如果需要修改页面样式,可以修改self.conversationMessageCollectionView属性
        self.conversationMessageCollectionView.backgroundColor = UIColor.brown
        
        addPhoneButton()
    }
    /// 当退出聊天页时,将这次聊天badge计数删除.
    override func viewWillDisappear(_ animated: Bool) {
        var dic = getMessageDic(PERSONMESSAGEKEY)
        dic[self.targetId] = 0
        UserDefaults.standard.setValue(dic, forKey: PERSONMESSAGEKEY)
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
            UIApplication.shared.open(URL(string: str)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary(["":""]), completionHandler: nil)
        }
    }


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
