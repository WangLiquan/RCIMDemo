//
//  CRRCIMDelegate.swift
//  Group
//
//  Created by Ethan.Wang on 2018/8/21.
//  Copyright © 2018年 Chuangrong. All rights reserved.
//

import Foundation

let RCIMDataSource = CRRCIMuserInfoDataSource.shared
///实现三个代理方法,选择自己需要的使用
class CRRCIMuserInfoDataSource: NSObject,RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource{
    static let shared = CRRCIMuserInfoDataSource()
    
    func getUserInfo(withUserId userId: String!, inGroup groupId: String!, completion: ((RCUserInfo?) -> Void)!) {
        guard userId != nil else { return }
        guard groupId != nil else { return }
    }
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        guard groupId != nil else { return }
    }
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        guard userId != nil else { return }
        /// 融云进行了线程保护,群组状态下获取数据,需要异步调用自己的请求方法
        DispatchQueue.global().async {

            /*** 通过网络请求根据userID从后台获取用户信息
            CRNetworking.getRongCloudPersonNameAndHeadimage(userId: userId, success: { (response) in
                guard let model = response as? CRGetPersonResponseModel else { return }
                let userinfo = RCUserInfo.init(userId: userId, name: model.name, portrait: basePicPath + model.head_img)
                ///通过completion回调返回获取的用户数据
                completion(userinfo)
            }) { (error) in
                CRPrint("获取头像姓名失败")
            }
            */
        }
    }


}
