require 'spec_helper_acceptance'

describe 'puppet class' do
    context 'default params' do
        it 'should install' do
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

            expect( apply_manifest( manifest ).exit_code ).to_not eq(1)
        end


        describe package('honeytail') do
            it { should be_installed }
        end

        describe file('/etc/honeytail/conf.d/test.conf') do
            it { should be_a_file }
        end

        describe service('honeytail@test') do
            it { should be_enabled }
        end


        describe file('/etc/honeytail/conf.d/test.conf') do
            its(:content) { should match /SampleRate = 2/ }
        end

        it 're-apply without SampleRate' do
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

            expect( apply_manifest( manifest ).exit_code ).to_not eq(1)
        end

        # SampleRate should be gone from configuration
        describe file('/etc/honeytail/conf.d/test.conf') do
            its(:content) { should_not match /SampleRate/ }
        end

    end
end