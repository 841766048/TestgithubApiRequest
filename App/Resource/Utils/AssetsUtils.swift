#if os(OSX)
 typealias Image  = NSImage
 typealias ImageName = NSImage.Name
#elseif os(iOS)
 import UIKit

 typealias Image  = UIImage
 typealias ImageName = String
#endif

extension Image {
 static var assets_home_maillist: Image? { return Image(named: ImageName("home_maillist")) }
 static var assets_home_notice: Image? { return Image(named: ImageName("home_notice")) }
 static var assets_home_scan: Image? { return Image(named: ImageName("home_scan")) }
 static var assets_home_search_icon: Image? { return Image(named: ImageName("home_search_icon")) }
 static var assets_smallArrow: Image? { return Image(named: ImageName("smallArrow")) }
 static var assets_LOGO: Image? { return Image(named: ImageName("LOGO")) }
 static var assets_selectPass: Image? { return Image(named: ImageName("selectPass")) }
 static var assets_uncheckedPass: Image? { return Image(named: ImageName("uncheckedPass")) }
 static var assets_ICON_confirmPsw: Image? { return Image(named: ImageName("ICON_confirmPsw")) }
 static var assets_ICON_fankui: Image? { return Image(named: ImageName("ICON_fankui")) }
 static var assets_ICON_guanyu: Image? { return Image(named: ImageName("ICON_guanyu")) }
 static var assets_ICON_newPsw: Image? { return Image(named: ImageName("ICON_newPsw")) }
 static var assets_ICON_originalPsw: Image? { return Image(named: ImageName("ICON_originalPsw")) }
 static var assets_ICON_ribao: Image? { return Image(named: ImageName("ICON_ribao")) }
 static var assets_ICON_yuebao: Image? { return Image(named: ImageName("ICON_yuebao")) }
 static var assets_setUp: Image? { return Image(named: ImageName("setUp")) }
 static var assets_home_normal: Image? { return Image(named: ImageName("home_normal")) }
 static var assets_home_selected: Image? { return Image(named: ImageName("home_selected")) }
 static var assets_order_normal: Image? { return Image(named: ImageName("order_normal")) }
 static var assets_order_selected: Image? { return Image(named: ImageName("order_selected")) }
 static var assets_personal_normal: Image? { return Image(named: ImageName("personal_normal")) }
 static var assets_personal_selected: Image? { return Image(named: ImageName("personal_selected")) }
 static var assets_resources_normal: Image? { return Image(named: ImageName("resources_normal")) }
 static var assets_resources_selected: Image? { return Image(named: ImageName("resources_selected")) }
 static var assets_lishijilu: Image? { return Image(named: ImageName("lishijilu")) }
 static var assets_navigation_back_normal: Image? { return Image(named: ImageName("navigation_back_normal")) }
 static var assets_电杆: Image? { return Image(named: ImageName("电杆")) }
}
