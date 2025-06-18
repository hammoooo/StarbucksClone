

import SwiftUI
import KakaoSDKCommon


@main
struct umcApp: App {
    
    init() {
            // kakao sdk 초기화
            let kakaoAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        }
    
    var body: some Scene {
        WindowGroup {
            //LoginView(id: .constant(""), pwd: .constant(""))
            //TabView()
            //RootView()
            StoreMapView()
        }
    }
}
