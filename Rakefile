require 'bundler'
require 'socket'

Bundler.setup
Bundler.require

PROVISIONING_PROFILE = 'Provisioning/Resilience_Ad_Hoc.mobileprovision'
TESTFLIGHT_API_TOKEN  = ENV['API_TOKEN']
TESTFLIGHT_TEAM_TOKEN = ENV['TEAM_TOKEN']

def scheme
  # Xcode.workspace(:Resilience).project(:Resilience).target(:Resilience)
  Xcode.workspace(:Resilience).scheme(:Resilience)
end

#
# BEGIN RAKEFILE
#
task :ci => ['adhoc:testflight', 'release:package']

desc "Setup project dependencies"
task :setup do
  sh 'cd Resilience; pod setup; pod install'
end

desc "Update project dependencies"
task :update_dependencies do
  sh 'cd Resilience; pod install'
end

task :__load_workspace do
  @main_builder = scheme.builder
  @main_builder.profile   = PROVISIONING_PROFILE
  @main_builder.identity  = 'iPhone Developer'
  cert_password = ENV['CERT_PASSWORD']
  unless cert_password.nil?
    keychain = Xcode::Keychain.temp
    keychain.import 'Provisioning/dist.cer', ""
    keychain.import 'Provisioning/apple.cer', ""
    keychain.import 'Provisioning/dist.p12', cert_password
    @main_builder.keychain = keychain
    @main_builder.identity = keychain.identities.first
  end
end

desc "Clean the project"
task :clean => :__load_workspace do
  @main_builder.clean
end

desc "Build the "
task :build => [:clean, :update_dependencies, :__load_workspace] do
  @main_builder.config.info_plist do |info|
    info.version = ENV['TRAVIS_BUILD_NUMBER']||"#{Socket.gethostname}-SNAPSHOT"
    info.save
  end
  @main_builder.build
end

desc "Test "
task :test => [:update_dependencies, :__load_workspace] do
  @main_builder.test
end

desc "Package (.ipa & .dSYM.zip) "
task :package => [:build, :__load_workspace] do
  @main_builder.package
end

desc "Upload the config to testflight / s3"
task :deploy  => [:package, :__load_workspace] do
  @main_builder.deploy :testflight,
    { api_token: TESTFLIGHT_API_TOKEN,
      team_token: TESTFLIGHT_TEAM_TOKEN,
      notes: `git log -n 1`,
      ists: ['Internal'] }
  @main_builder.deploy :s3, { bucket: 'resilience-ipa' }
end
