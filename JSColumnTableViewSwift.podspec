#
# Be sure to run `pod lib lint JSColumnTableViewSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JSColumnTableViewSwift'
  s.version          = '0.1.0'
  s.summary          = 'JSColumnTableViewSwift is an auto-layouting columned UITableView.'

  s.description      = <<-DESC
This is a description of the magnificent JSColumnTableViewSwift that will give you fast implementation of columned UITableView's.
                       DESC

  s.homepage         = 'https://github.com/LuisXavierJS/JSColumnTableSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jorge Luis Xavier' => '' }
  s.source           = { :git => 'https://github.com/LuisXavierJS/JSColumnTableSwift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = [
      'ColumnTableView/ColumnContentView.swift',
      'ColumnTableView/ColumnsHeaderView.swift',
      'ColumnTableView/ColumnsTableView.swift',
      'ColumnTableView/ColumnsTableViewCell.swift',
      'ColumnTableView/ColumnsViewContainer.swift',
      'ColumnTableView/Helpers.swift'
    ]

end
