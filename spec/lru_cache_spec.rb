require 'spec_helper'

RSpec.describe LRUCache do
  context 'サイズが2の時' do
    let(:cache) { LRUCache.new(2) }

    it ':aが消える' do
      cache[:a] = 'alpha'
      cache[:b] = 'bravo'
      cache[:c] = 'charlie'

      expect(cache[:a]).to be_nil
    end

    it ':bが消える' do
      cache[:a] = 'alpha'
      cache[:b] = 'bravo'
      cache[:a]
      cache[:c] = 'charlie'

      expect(cache[:b]).to be_nil
    end

    it ':aが消える' do
      cache[:a] = 'alpha'
      cache[:b] = 'bravo'
      cache[:a]
      cache[:b]
      cache[:c] = 'charlie'

      expect(cache[:a]).to be_nil
    end
  end
end
