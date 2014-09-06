require 'spec_helper'

RSpec.describe LRUCache do
  context 'サイズが2の時' do
    let(:cache) { LRUCache.new(2) }

    it ':aが消える' do
      cache[:a] = 'alpha'
      cache[:b] = 'bravo'
      cache[:c] = 'charlie'
      expect(cache.to_hash).to match(
        b: 'bravo',
        c: 'charlie',
      )
    end

    it ':bが消える' do
      cache[:a] = 'alpha'
      cache[:b] = 'bravo'
      cache[:a]
      cache[:c] = 'charlie'
      expect(cache.to_hash).to match(
        a: 'alpha',
        c: 'charlie',
      )
    end

    it ':aが消える' do
      cache[:a] = 'alpha'
      cache[:b] = 'bravo'
      cache[:a]
      cache[:b]
      cache[:c] = 'charlie'
      expect(cache.to_hash).to match(
        b: 'bravo',
        c: 'charlie',
      )
    end
  end
end
