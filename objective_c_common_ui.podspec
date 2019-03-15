
Pod::Spec.new do |s|
  s.name             = 'objective_c_common_ui'
  s.version          = '0.0.1'
  s.summary          = 'A common ui for objective_c'

  s.description      = <<-DESC
This pod file contains common ui files. common ui such like a pull refresh, buttons, checkbox ..etc .
                       DESC

  s.homepage         = 'https://github.com/EmptyOps/objective_c_common_ui'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EmptyOps' => 'hsquaretechnology@gmail.com' }
  s.source           = { :git => 'https://github.com/EmptyOps/objective_c_common_ui.git', :tag => s.version.to_s }

  s.platform = :ios, '7.0'
  s.dependency 'objective_c_common_helpers'
  s.requires_arc = true

  s.source_files = 'objective_c_common_ui/Classes/**/*'

end
