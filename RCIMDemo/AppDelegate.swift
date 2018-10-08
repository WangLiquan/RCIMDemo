//
//  AppDelegate.swift
//  RCIMDemo
//
//  Created by Ethan.Wang on 2018/9/21.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ///在官网上申请的App Key. 同时获取的App Secret我们并不需要,是后台需要的.
        RCIM.shared().initWithAppKey("y745wfm8yjzbv")
        ///是否将用户信息和群组信息在本地持久化存储
        RCIM.shared().enablePersistentUserInfoCache = false
        ///是否在发送的所有消息中携带当前登录的用户信息
        RCIM.shared().enableMessageAttachUserInfo = true
        ///收到信息的代理
        RCIM.shared().receiveMessageDelegate = self
        ///用户信息提供代理
        RCIM.shared().userInfoDataSource = RCIMDataSource
        RCIM.shared().groupInfoDataSource = RCIMDataSource
        RCIM.shared().groupUserInfoDataSource = RCIMDataSource

        ///融云并不管理用户信息,不管是登录账号还是与之聊天的人的信息,所以我们需要在连接融云服务器时就将登录账号的昵称与头像设定好.这样才能在会话页显示正确的数据
        /// token也是从后台获取,理论上顺序是登录时获取后台传来的token,再使用这个token链接融云服务.
        RCIM.shared().connect(withToken: "dQBWciyYegIh7UpkkirIqP/V9gk1Pf9ZryuCvogQH2pvFx4QxzGsb+jL8Kx0zVRqv//9jeTWRkR5S5eole51Dw==", success: { (userId) in
            ///这两个都是从后台获取
            let username = "登录账号的昵称"
            let iconurl = "登录账号的头像路径"
            let currentUserInfo = RCUserInfo(userId: userId!, name: username, portrait: iconurl)
            ///将设置的用户信息赋值给登录账号
            RCIM.shared().currentUserInfo = currentUserInfo
        }, error: { (error) in
            print(error)
        }) {
            print("token错误")
        }

        window?.rootViewController = UINavigationController(rootViewController: ViewController())

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
//MARK: - 融云获取信息delegate
extension AppDelegate: RCIMReceiveMessageDelegate {

    /// 收到信息时的回调方法
    ///
    /// - Parameters:
    ///   - message: 信息主体
    ///   - left: 剩余数量,当一次有大量的信息传入时,融云选择重复调用这个方法的形式,left就是剩余未接收的信息数量
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        switch message.conversationType {
            ///群组聊天数据
        case .ConversationType_GROUP:
            var dic = getMessageDic(GROUPMESSAGEKEY)
            ///以发送者的targetID作为Key将数量存储进字典
            guard var num = dic[message.targetId] else {
                dic[message.targetId] = 1
                UserDefaults.standard.setValue(dic, forKey: GROUPMESSAGEKEY)
                ///获取信息,发送通知
                NotificationCenter.default.post(name: Notification.Name(rawValue: "onRCIMReceive"), object: nil)
                return
            }
            ///如果字典内已经有发送者的targetID字段,将存储的消息数量加1
            num += 1
            dic[message.targetId] = num
            ///保存
            UserDefaults.standard.setValue(dic, forKey: GROUPMESSAGEKEY)
            ///个人聊天信息
        case .ConversationType_PRIVATE:
            var dic = getMessageDic(PERSONMESSAGEKEY)
            ///以发送者的targetID作为Key将数量存储进字典
            guard var num = dic[message.targetId] else {
                dic[message.targetId] = 1
                UserDefaults.standard.setValue(dic, forKey: PERSONMESSAGEKEY)
                ///获取信息,发送通知
                NotificationCenter.default.post(name: Notification.Name(rawValue: "onRCIMReceive"), object: nil)
                return
            }
            ///如果字典内已经有发送者的targetID字段,将存储的消息数量加1
            num += 1
            dic[message.targetId] = num
            ///保存
            UserDefaults.standard.setValue(dic, forKey: PERSONMESSAGEKEY)
        default:
            return
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "onRCIMReceive"), object: nil)
    }
}

