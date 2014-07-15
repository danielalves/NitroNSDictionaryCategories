Pod::Spec.new do |s|
  s.name         = "NitroNSDictionaryCategories"
  s.version      = "1.0.0"
  s.summary      = "Parsing and utility categories for iOS NSDictionary."
  s.homepage     = "http://github.com/danielalves/NitroNSDictionaryCategories"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Daniel L. Alves"
  s.social_media_url   = "http://twitter.com/alveslopesdan"
  s.source       = { :git => "https://github.com/danielalves/NitroNSDictionaryCategories.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files  = "NitroNSDictionaryCategories/NitroNSDictionaryCategories"
  s.requires_arc = true
end
