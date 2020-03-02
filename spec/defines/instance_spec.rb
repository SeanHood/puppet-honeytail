# frozen_string_literal: true

require 'spec_helper'

describe 'honeytail::instance' do
  let(:title) { 'mysql' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'without config' do
        it { is_expected.to compile.and_raise_error(%r{Evaluation Error}) }
      end

      context 'with config' do
        let(:params) do
          {
            'config' => {
              'Required Options' => {
                'ParserName' => 'mysql',
                'WriteKey'   => 'REDACTED',
                'LogFiles'   => '/var/lib/mysql/slow-query.log',
                'Dataset'    => 'mysql',
              },
            },
          }
        end

        it { is_expected.to compile }

        it { is_expected.to have_ini_setting_resource_count(4) }

        it {
          is_expected.to contain_ini_setting('/etc/honeytail/conf.d/mysql.conf [Required Options] ParserName').with(
            ensure: 'present',
            section: 'Required Options',
            setting: 'ParserName',
            value: 'mysql',
            path: '/etc/honeytail/conf.d/mysql.conf',
          )
        }

        it {
          is_expected.to contain_ini_setting('/etc/honeytail/conf.d/mysql.conf [Required Options] WriteKey').with(
            value: 'REDACTED',
          )
        }

        it {
          is_expected.to contain_ini_setting('/etc/honeytail/conf.d/mysql.conf [Required Options] LogFiles').with(
            value: '/var/lib/mysql/slow-query.log',
          )
        }

        it {
          is_expected.to contain_ini_setting('/etc/honeytail/conf.d/mysql.conf [Required Options] Dataset').with(
            value: 'mysql',
          )
        }

        it {
          is_expected.to contain_service('honeytail@mysql').with(
            ensure: 'running',
            enable: true,
          )
        }
      end
    end
  end
end
