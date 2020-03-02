# frozen_string_literal: true

require 'spec_helper'

describe 'honeytail' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('honeytail::package') }
      it { is_expected.to contain_class('honeytail::config') }
      it { is_expected.to contain_class('honeytail::service') }

      it {
        is_expected.to contain_file('/etc/honeytail/conf.d/')
          .with(ensure: 'directory')
          .that_requires('Package[honeytail]')
      }

      it { is_expected.to contain_systemd__unit_file('honeytail@.service') }

      context 'from repo' do
        it {
          is_expected.to contain_package('honeytail').with(
            ensure: 'installed',
            source: nil,
          )
        }
      end

      context 'direct download' do
        let(:params) do
          { direct_download: 'https://honeycomb.io/download/honeytail/linux/honeytail-X.XXX-1.x86_64.rpm' }
        end

        it {
          is_expected.to contain_package('honeytail').with(
            ensure: 'installed',
            source: '/var/cache/honeytail_pkgs/honeytail-X.XXX-1.x86_64.rpm',
          )
        }
      end
    end
  end
end
