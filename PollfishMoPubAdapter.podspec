Pod::Spec.new do |s|

    s.name                  = 'PollfishMoPubAdapter'
    s.version               = '6.2.2.0'
    s.summary               = 'Pollfish iOS Adapter for MoPub Mediation'
    s.module_name           = 'PollfishMoPubAdapter'
    s.description           = 'Adapter for publishers looking to use MoPub mediation to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.'
    s.homepage              = 'https://www.pollfish.com/publisher'
    s.documentation_url     = "https://pollfish.com/docs/ios-mopub-adapter"
    s.license               = { :type => 'Commercial', :text => 'See https://www.pollfish.com/terms/publisher' }
    s.authors               = { 'Pollfish Inc.' => 'support@pollfish.com' }

    s.source                = { :git => 'https://github.com/pollfish/ios-mopub-adapter.git', :tag => s.version.to_s }
    s.platform              = :ios, '10.0'
    s.static_framework      = true
    s.requires_arc          = true
    s.swift_versions        = ['5.3']

    s.vendored_frameworks   = 'PollfishMoPubAdapter.xcframework'
    s.dependencies          = { 'Pollfish'=> "~> 6.2.2", 'mopub-ios-sdk'=> '>= 5.17'}

    s.pod_target_xcconfig   = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
    
end
