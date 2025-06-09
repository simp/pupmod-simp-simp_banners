require 'spec_helper'

describe 'simp_banners::fetch' do
  context 'with known banners' do
    it { is_expected.to run.with_params('simp').and_return(%r{ATTENTION}) }
    it { is_expected.to run.with_params('us/department_of_commerce').and_return(%r{Department of Commerce}i) }
  end

  context 'with an unknown banner' do
    it { expect { is_expected.to run.with_params('_nope_') }.to raise_error(%r{Banner '_nope_' not found}) }
  end

  context 'format options' do
    context 'cr_escape' do
      it { is_expected.to run.with_params('simp', { 'cr_escape' => true }).and_return(%r{ATTENTION.+\\n}) }
      it { is_expected.to run.with_params('simp', { 'cr_escape' => true }).and_return(%r{(?!\n)}) }
    end

    context 'file_source' do
      it { is_expected.to run.with_params('simp', { 'file_source' => true }).and_return('puppet:///simp_banners/simp') }
      it { is_expected.to run.with_params('us/department_of_commerce', { 'file_source' => true }).and_return('puppet:///simp_banners/us/department_of_commerce') }
    end

    it 'overrides all other settings' do
      format_options = {
        'file_source' => true,
        'cr_escape'   => true
      }

      is_expected.to run.with_params('simp', format_options).and_return('puppet:///simp_banners/simp')
    end
  end
end
