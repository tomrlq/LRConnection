
Pod::Spec.new do |s|

  s.name         = "LRConnection"
  s.version      = "0.2.1"
  s.summary      = "An HTTP library that makes networking easier"
  s.description  = <<-DESC
  LRConnection is an HTTP library that makes networking easier
                   DESC
  s.homepage     = "https://github.com/tomrlq/LRConnection"
  s.license      = "MIT"
  s.author             = { "Ruan Lingqi" => "tomrlq@foxmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tomrlq/LRConnection.git", :tag => "#{s.version}" }
  s.source_files  = "LRConnection/LRConnection/LRConnection.h"
  s.public_header_files = "LRConnection/LRConnection/LRConnection.h"
  s.requires_arc = true

  s.subspec 'Core' do |ss|
    ss.source_files = 'LRConnection/LRConnection/*.{h,m}'
    ss.public_header_files = "LRConnection/LRConnection/LRConnectionManager.h"
    ss.exclude_files = 'LRConnection/LRConnection/LRConnection.h'
  end

end
