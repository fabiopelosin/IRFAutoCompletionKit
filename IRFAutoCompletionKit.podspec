Pod::Spec.new do |s|
  s.name         = "IRFAutoCompletionKit"
  s.version      = "0.1.0"
  s.summary      = "Small kit to support auto completion"
  s.homepage     = "https://github.com/irrationalfab/IRFAutoCompletionKit"
  s.screenshots  = "https://raw.github.com/irrationalfab/IRFAutoCompletionKit/master/Web/Screen%20Shot%200.png"
  s.license      = 'MIT'
  s.author       = { "Fabio Pelosin" => "fabiopelosin@gmail.com" }
  s.source       = { :git => "https://github.com/irrationalfab/IRFAutoCompletionKit.git", :tag => s.version.to_s }

  s.platform = :osx, '10.7'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'

  s.dependency 'IRFEmojiCheatSheet'
end
