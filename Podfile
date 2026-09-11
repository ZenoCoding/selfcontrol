source 'https://cdn.cocoapods.org/'

minVersion = '10.13'

platform :osx, minVersion

# cocoapods-prune-localizations doesn't appear to auto-detect pods properly, so using a manual list
supported_locales = ['Base', 'da', 'de', 'en', 'es', 'fr', 'it', 'ja', 'ko', 'nl', 'pt-BR', 'sv', 'tr', 'zh-Hans']
plugin 'cocoapods-prune-localizations', { :localizations => supported_locales }

target "SelfControl" do
    use_frameworks! :linkage => :static
    pod 'MASPreferences', '~> 1.1.4'
    pod 'TransformerKit', '~> 1.1.1'
    pod 'FormatterKit/TimeIntervalFormatter', '~> 1.8.0'
    pod 'LetsMove', '~> 1.24'
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.3.0'
    
    # Add test target
    target 'SelfControlTests' do
        inherit! :complete
    end
end

target "SelfControl Killer" do
    use_frameworks! :linkage => :static
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.3.0'
end

# we can't use_frameworks on these because they're command-line tools
# Sentry says we need use_frameworks, but they seem to work OK anyway?
target "SCKillerHelper" do
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.3.0'
end
target "selfcontrol-cli" do
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.3.0'
end
target "org.eyebeam.selfcontrold" do
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.3.0'
end

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if Gem::Version.new(bc.build_settings['MACOSX_DEPLOYMENT_TARGET']) < Gem::Version.new(minVersion)
#            if bc.build_settings['MACOSX_DEPLOYMENT_TARGET'] == '8.0'
               bc.build_settings['MACOSX_DEPLOYMENT_TARGET'] = minVersion
           end
       end
   end

   # Sentry 7.3.0 relies on std::terminate_handler/std::set_terminate but
   # does not include <exception>, which current Xcode/libc++ requires.
   sentry_cpp_exception_path = 'Pods/Sentry/Sources/SentryCrash/Recording/Monitors/SentryCrashMonitor_CPPException.cpp'
   if File.exist?(sentry_cpp_exception_path)
       sentry_cpp_exception = File.read(sentry_cpp_exception_path)
       include_exception = "#include <exception>\n"
       unless sentry_cpp_exception.include?(include_exception)
           sentry_cpp_exception.sub!("#include <dlfcn.h>\n", "#include <dlfcn.h>\n#{include_exception}")
           File.chmod(0644, sentry_cpp_exception_path)
           File.write(sentry_cpp_exception_path, sentry_cpp_exception)
       end
   end

   sentry_machine_context_path = 'Pods/Sentry/Sources/SentryCrash/Recording/Tools/SentryCrashMachineContext.c'
   if File.exist?(sentry_machine_context_path)
       sentry_machine_context = File.read(sentry_machine_context_path)
       include_ucontext64 = "#include <sys/_types/_ucontext64.h>\n"
       patched_sentry_machine_context = sentry_machine_context.gsub(include_ucontext64, '')
       patched_sentry_machine_context.sub!("#include \"SentryCrashMachineContext.h\"\n", "#{include_ucontext64}#include \"SentryCrashMachineContext.h\"\n")
       if patched_sentry_machine_context != sentry_machine_context
           File.chmod(0644, sentry_machine_context_path)
           File.write(sentry_machine_context_path, patched_sentry_machine_context)
       end
   end

   transformerkit_files = [
       'Pods/TransformerKit/Sources/NSValueTransformerName.h',
       'Pods/TransformerKit/Sources/NSValueTransformer+TransformerKit.m'
   ]
   transformerkit_files.each do |transformerkit_path|
       next unless File.exist?(transformerkit_path)

       transformerkit_source = File.read(transformerkit_path)
       patched_transformerkit_source = transformerkit_source
           .gsub('#import <Availability.h>', '#import <AvailabilityMacros.h>')
           .gsub('@import Darwin.Availability;', '#import <AvailabilityMacros.h>')
       next if patched_transformerkit_source == transformerkit_source

       File.chmod(0644, transformerkit_path)
       File.write(transformerkit_path, patched_transformerkit_source)
   end

   transformerkit_date_path = 'Pods/TransformerKit/Sources/TTTDateTransformers.m'
   if File.exist?(transformerkit_date_path)
       transformerkit_date = File.read(transformerkit_date_path)
       patched_transformerkit_date = transformerkit_date
           .gsub("@import Darwin.C.time;\n@import Darwin.C.xlocale;\n", "#import <time.h>\n#import <xlocale.h>\n")
       if patched_transformerkit_date != transformerkit_date
           File.chmod(0644, transformerkit_date_path)
           File.write(transformerkit_date_path, patched_transformerkit_date)
       end
   end

   letsmove_path = 'Pods/LetsMove/PFMoveApplication.m'
   if File.exist?(letsmove_path)
       letsmove_source = File.read(letsmove_path)
       patched_letsmove_source = letsmove_source.gsub('#import "PFMoveApplication.h"', '#import "LetsMove/PFMoveApplication.h"')
       if patched_letsmove_source != letsmove_source
           File.chmod(0644, letsmove_path)
           File.write(letsmove_path, patched_letsmove_source)
       end
   end

   letsmove_header_path = 'Pods/LetsMove/PFMoveApplication.h'
   unless File.exist?(letsmove_header_path)
       File.write(letsmove_header_path, <<~HEADER)
       void PFMoveToApplicationsFolderIfNecessary(void);
       bool PFMoveIsInProgress(void);
       HEADER
   end

   Dir.glob('Pods/Target Support Files/Pods-SelfControl*/Pods-SelfControl*-resources.sh').each do |resources_script_path|
       resources_script = File.read(resources_script_path)
       patched_resources_script = resources_script.gsub(
           'MASPreferences/MASPreferences.framework/en.lproj/MASPreferencesWindow.nib',
           'MASPreferences/MASPreferences.framework/Resources/en.lproj/MASPreferencesWindow.nib'
       )
       next if patched_resources_script == resources_script

       File.chmod(0755, resources_script_path)
       File.write(resources_script_path, patched_resources_script)
   end
end
