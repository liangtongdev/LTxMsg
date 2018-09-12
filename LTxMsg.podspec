Pod::Spec.new do |s|
  s.name         = "LTxMsg"
  s.version      = "0.0.3"
  s.summary      = "APNs消息+管理组件. "
  s.license      = "MIT"
  s.author             = { "liangtong" => "liangtongdev@163.com" }

  s.homepage     = "https://github.com/liangtongdev/LTxMsg"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/liangtongdev/LTxMsg.git", :tag => "#{s.version}", :submodules => true }

  s.dependency 'LTxEepMSippr'
  s.default_subspecs = 'LTxMsgForSippr'

  # LTxMsgForSippr
  s.subspec 'LTxMsgForSippr' do |sp|
    # Model
    sp.subspec 'Model' do |ssp|
      ssp.source_files  =  "LTxMsg/LTxMsgForSippr/Model/*.{h,m}"
      ssp.public_header_files = "LTxMsg/LTxMsgForSippr/Model/**/*.h"
    end
    # Views
    sp.subspec 'Views' do |ssp|
      ssp.source_files  =  "LTxMsg/LTxMsgForSippr/Views/*.{h,m}"
      ssp.public_header_files = "LTxMsg/LTxMsgForSippr/Views/**/*.h"
      ssp.resource  =  "LTxMsg/LTxMsgForSippr/Views/*.xib"
      ssp.dependency 'LTxMsg/LTxMsgForSippr/Model'
    end
    # Controllers
    sp.subspec 'Controllers' do |ssp|
      ssp.source_files  =  "LTxMsg/LTxMsgForSippr/Controllers/*.{h,m}"
      ssp.public_header_files = "LTxMsg/LTxMsgForSippr/Controllers/**/*.h"
      ssp.dependency 'LTxMsg/LTxMsgForSippr/Views'
    end

    # Core
    sp.subspec 'Core' do |core|
        core.public_header_files = "LTxMsg/LTxMsgForSippr/LTxMsgForSippr.h"
        core.source_files  =  "LTxMsg/LTxMsgForSippr/LTxMsgForSippr.h"
        core.dependency 'LTxMsg/LTxMsgForSippr/Controllers'
    end

  end

end
