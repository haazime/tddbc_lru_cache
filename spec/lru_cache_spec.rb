require 'spec_helper'

RSpec.describe LRUCache, 'サイズを固定' do
  let(:cache) { LRUCache.new(2) }

  it '何も消えない' do
    expect(cache.to_hash).to match({})
  end

  it '何も消えない' do
    cache[:a] = 'alpha'
    expect(cache.to_hash).to match(
      a: 'alpha'
    )
  end

  it '何も消えない' do
    cache[:a] = 'alpha'
    cache[:b] = 'bravo'
    expect(cache.to_hash).to match(
      a: 'alpha',
      b: 'bravo',
    )
  end

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

RSpec.describe LRUCache, 'サイズを後で変更' do
  let(:cache) { LRUCache.new(5) }

  before do
    cache[:a] = 'alpha'
    cache[:b] = 'bravo'
    cache[:c] = 'charlie'
    cache[:d] = 'delta'
    cache[:e] = 'echo'
  end

  it ':a,:b,:cが消える' do
    cache.resize(2)
    expect(cache.to_hash).to match(
      d: 'delta',
      e: 'echo',
    )
  end

  it ':a,:b,:dが消える' do
    cache[:a]
    cache[:c]
    cache[:e]
    cache.resize(2)
    expect(cache.to_hash).to match(
      c: 'charlie',
      e: 'echo'
    )
  end
end
