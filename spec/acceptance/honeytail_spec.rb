require 'spec_helper_acceptance'

describe 'honeytail class' do
  context 'Basic Config' do
    it 'Apply Manifest' do
      manifest = <<-EOS
          class {'honeytail':
              direct_download => 'https://honeycomb.io/download/honeytail/linux/honeytail-1.762-1.x86_64.rpm'
          }

          honeytail::instance { 'test':
              config => {
                  'Required Options' => {
                      'ParserName' => 'mysql',
                      'WriteKey'   => 'REDACTED',
                      'LogFiles'   => '/var/lib/mysql/slow-query.log',
                      'Dataset'    => 'mysql'
                  },
                  'Application Options' => {
                      'SampleRate' => '2'
                  }
              }
          }
      EOS

      expect(apply_manifest(manifest).exit_code).not_to eq(1)
    end

    describe package('honeytail') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/honeytail/conf.d/test.conf') do
      it { is_expected.to be_a_file }
    end

    describe service('honeytail@test') do
      it { is_expected.to be_enabled }
    end

    describe file('/etc/honeytail/conf.d/test.conf') do
      it { is_expected.to be_a_file }
      its(:content) { is_expected.to match %r{SampleRate = 2} }
    end
  end

  context 'Re-apply manifest without SampleRate' do
    it 'Apply Manifest' do
      manifest = <<-EOS
          class {'honeytail':
              direct_download => 'https://honeycomb.io/download/honeytail/linux/honeytail-1.762-1.x86_64.rpm'
          }

          honeytail::instance { 'test':
              config => {
                  'Required Options' => {
                      'ParserName' => 'mysql',
                      'WriteKey'   => 'REDACTED',
                      'LogFiles'   => '/var/lib/mysql/slow-query.log',
                      'Dataset'    => 'mysql'
                  },
              }
          }
      EOS

      expect(apply_manifest(manifest).exit_code).not_to eq(1)
    end

    # SampleRate should be gone from configuration
    describe file('/etc/honeytail/conf.d/test.conf') do
      it { is_expected.to be_a_file }
      its(:content) { is_expected.not_to match %r{SampleRate} }
    end
  end
end
