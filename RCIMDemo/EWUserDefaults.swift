//
//  UserDefault+Extension.swift
//  Group
//
//  Created by Ethan.Wang on 2018/8/25.
//  Copyright © 2018年 Chuangrong. All rights reserved.
//

import Foundation
///群组聊天标识
let GROUPMESSAGEKEY = "groupMessageNum"
///个人聊天标识
let PERSONMESSAGEKEY = "personMessageNum"

///将消息数量存储进userDefaults,获取message存储字典.如果没有则新建
func getMessageDic(_ key: String) -> [String: Int] {
    guard let dic = UserDefaults.standard.value(forKey: key) as? [String: Int] else {
        let dic = [String: Int]()
        UserDefaults.standard.setValue(dic, forKey: key)
        return dic
    }
    return dic
}
