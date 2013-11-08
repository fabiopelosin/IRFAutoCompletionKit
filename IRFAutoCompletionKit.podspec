Pod::Spec.new do |s|
  s.name         = "IRFAutoCompletionKit"
  s.version      = "0.1.0"
  s.summary      = "Small kit to support auto completion"
  s.homepage     = "https://github.com/irrationalfab/IRFAutoCompletionKit"
  s.screenshots  = "https://raw.github.com/irrationalfab/IRFAutoCompletionKit/master/Web/Screen%20Shot 0.png"
  s.license      = 'MIT'
  s.author       = { "Fabio Pelosin" => "fabiopelosin@gmail.com" }
  s.source       = { :git => "https://github.com/irrationalfab/IRFAutoCompletionKit", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'Classes'

  s.subspec 'CompletionProviders' do |ss|
    ss.source_files = 'Classes/CompletionProviders'
  end

  s.subspec 'ViewController' do |ss|
    ss.platform = :osx
    ss.source_files = 'Classes/osx/ViewController'
    ss.resources = 'Classes/osx/ViewController/MMPopOverEmojiViewController.xib'
  end

  s.dependency 'IRFEmojiCheatSheet'

end
