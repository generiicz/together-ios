platform :ios, '9.2'
inhibit_all_warnings!
use_frameworks!

def ui_components
    pod 'SideMenu'
    pod 'JSQMessagesViewController'
    pod 'TTRangeSlider'
    pod 'PKHUD', '~> 4.0'
end

def network_components
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.0'
    pod 'Moya'
    pod 'Kingfisher'
end

def core_components
    pod 'RxSwift', '~> 3.0.0-beta.1'
    pod 'RxCocoa', '~> 3.0.0-beta.1'
    pod 'PromiseKit'
    pod 'SugarRecord/CoreData'
    pod 'SwiftyJSON'
    pod 'ObjectMapper'
end

def data_components
    pod 'Locksmith'
    pod 'SwiftyUserDefaults'
end

def social_components
    pod 'Fabric'
    # twitter
    pod 'TwitterKit'
    pod 'TwitterCore'
    # facebook
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    # map
    pod 'GoogleMaps'
    pod 'GooglePlaces'
end

target 'Together' do
    ui_components
    network_components
    core_components
    data_components
    social_components
end
