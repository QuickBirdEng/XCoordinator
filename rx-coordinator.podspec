Pod::Spec.new do |spec|
  spec.name         = 'rx-coordinator'
  spec.version      = '0.3.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/jdisho/RxCoordinator'
  spec.authors      = { 'Stefan Kofler' => 'stefan.kofler@quickbirdstudios.com' }
  spec.summary      = 'Navigation framework based on coordinator pattern.'
  spec.source       = { :git => 'https://github.com/jdisho/RxCoordinator.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.tvos.deployment_target = '9.0'
  spec.source_files = 'RxCoordinator/Sources/*.swift'
  spec.framework  = 'Foundation'
  spec.framework  = 'UIKit'
  spec.dependency 'RxSwift', '~> 4.0'
  spec.dependency 'RxCocoa', '~> 4.0'
end