require 'spec_helper'

RSpec.describe AfterShip::DateUtils do
  context 'parse' do
    it 'empty string' do
      date = AfterShip::DateUtils.parse('')
      expect(date).to be_nil
    end

    it 'nil' do
      date = AfterShip::DateUtils.parse(nil)
      expect(date).to be_nil
    end

    it 'YYYY-MM-DD' do
      date     = AfterShip::DateUtils.parse('2014-07-29')
      expected = Date.parse('2014-07-29')
      expect(date).to eq(expected)
      expect(date.to_s).to eq('2014-07-29')
      expect(date.strftime('%Y-%m-%d %H:%M:%S')).to eq('2014-07-29 00:00:00')
    end

    it 'YYYY-MM-DDTHH:MM:SS' do
      date     = AfterShip::DateUtils.parse('2014-07-29T16:08:23')
      expected = DateTime.parse('2014-07-29T16:08:23')
      expect(date).to eq(expected)
      expect(date.to_s).to eq('2014-07-29T16:08:23+00:00')
      expect(date.strftime('%Y-%m-%d %H:%M:%S')).to eq('2014-07-29 16:08:23')
    end

    it 'YYYY-MM-DDTHH:MM:SSZ' do
      date     = AfterShip::DateUtils.parse('2014-07-29T16:08:23Z')
      expected = DateTime.parse('2014-07-29T16:08:23Z')
      expect(date).to eq(expected)
      expect(date.to_s).to eq('2014-07-29T16:08:23+00:00')
      expect(date.strftime('%Y-%m-%d %H:%M:%S')).to eq('2014-07-29 16:08:23')
    end

    it 'YYYY-MM-DDTHH:MM:SS+HH:MM' do
      date     = AfterShip::DateUtils.parse('2014-07-29T16:08:23+02:00')
      expected = DateTime.parse('2014-07-29T16:08:23+02:00')
      expect(date).to eq(expected)
      expect(date.to_s).to eq('2014-07-29T16:08:23+02:00')
      expect(date.strftime('%Y-%m-%d %H:%M:%S')).to eq('2014-07-29 16:08:23')
    end

    it 'YYYY-MM-DDTHH:MM:SS-HH:MM' do
      date     = AfterShip::DateUtils.parse('2014-07-29T16:08:23-02:00')
      expected = DateTime.parse('2014-07-29T16:08:23-02:00')
      expect(date).to eq(expected)
      expect(date.to_s).to eq('2014-07-29T16:08:23-02:00')
      expect(date.strftime('%Y-%m-%d %H:%M:%S')).to eq('2014-07-29 16:08:23')
    end

    it 'everything else raises an error' do
      expect { AfterShip::DateUtils.parse('xxx') }.to raise_error(ArgumentError)
    end
  end
end
