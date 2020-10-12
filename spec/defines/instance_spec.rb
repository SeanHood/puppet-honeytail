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

        it {
          is_expected.to contain_file('/etc/honeytail/conf.d/mysql.conf') \
            .with_content(%r{WriteKey = REDACTED}) \
            .with_content(%r{Dataset = mysql})
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
