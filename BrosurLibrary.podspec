Pod::Spec.new do |spec|
    spec.name = 'BrosurLibrary'
    spec.version = '1.0'
    spec.platform = :ios
    spec.source = { :git => 'https://DmitryKorotchenkov@bitbucket.org/DmitryKorotchenkov/brosurlibrary.git' }
    spec.requires_arc = true
    
    spec.subspec 'Builder' do |ss|
    	ss.dependency 'BrosurLibrary/Parser'
    	ss.dependency 'BrosurLibrary/UI'
    	ss.source_files = 'Classes/Builder/*'
    end
    
    
    spec.subspec 'Components' do |ss|
    	ss.source_files = 'Classes/Components/*'
    end
    
    spec.subspec 'Parser' do |ss|
    	ss.dependency 'BrosurLibrary/Paths'
    	ss.dependency 'BrosurLibrary/Components'
    	ss.source_files = 'Classes/Parser/*'
    end
    
    spec.subspec 'Paths' do |ss|
    	ss.source_files = 'Classes/Paths/*'
    end
    
    spec.subspec 'UI' do |ss|
    	ss.dependency 'BrosurLibrary/Paths'
    	ss.dependency 'BrosurLibrary/Components'
    	ss.source_files = 'Classes/UI/*'
    end
end