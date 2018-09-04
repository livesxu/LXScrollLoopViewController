
Pod::Spec.new do |s|

  s.name         = "LXScrollLoopViewController"
  s.version      = "0.1.0"
  s.summary      = "LXScrollLoopViewController"
  s.homepage     = "https://github.com/livesxu/LXScrollLoopViewController.git"
  s.license      = "MIT"
  s.author       = { "livesxu" => "livesxu@163.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/livesxu/LXScrollLoopViewController.git", :tag => s.version }
  s.source_files  = "LXScrollLoopViewController"
  s.frameworks    = 'UIKit'
  s.requires_arc  = true

end