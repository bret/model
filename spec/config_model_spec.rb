lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

ENV['HOST'] = 'http://google.com'
ENV['BROWSER'] = 'chrome'
ENV['RESULTS_EMAIL'] = 'foo@example.com'

require 'model'
require 'config_model'

describe ConfigModel do

  class HostsModel < ConfigModel
    key(:host)
    key(:browser)
    key(:results_email) { 'bar@example.com' }
    key(:username) { 'jonny5' }
  end

  it 'should return defined ENV values by default' do
    hosts = HostsModel.new
    expect(hosts.host).to eql 'http://google.com'
    expect(hosts.browser).to eql 'chrome'
  end

  it 'should return ENV values even if default exists in Model' do
    hosts = HostsModel.new
    expect(hosts.results_email).to eql 'foo@example.com'
  end

  it 'should not return the ENV values if another value is explicitly passed into the model' do
    hosts = HostsModel.new(browser: 'firefox')
    expect(hosts.browser).to eql 'firefox'
  end

  it 'should return default value if no corresponding ENV value is set' do
    hosts = HostsModel.new
    expect(hosts.username).to eql 'jonny5'
  end

end
