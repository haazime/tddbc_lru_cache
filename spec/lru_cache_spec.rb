RSpec.describe LRUCache, 'サイズを固定' do
  let(:cache) { LRUCache.new(2) }

  it '存在しないキーで取り出すとnilが返る' do
    expect(cache[:a]).to be_nil
  end

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

RSpec.describe LRUCache, 'サイズを5から2に変更' do
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

  it ':a,:b,:d,:cが消える' do
    cache[:a]
    cache[:c]
    cache[:e]
    cache.resize(2)
    cache[:f] = 'foxtrot'
    expect(cache.to_hash).to match(
      e: 'echo',
      f: 'foxtrot'
    )
  end
end

RSpec.describe LRUCache, 'サイズを3から5に変更' do
  let(:cache) { LRUCache.new(3) }

  before do
    cache[:x] = 'x-ray'
    cache[:y] = 'yankee'
    cache[:z] = 'zulu'
  end

  it '何も消えない' do
    cache[:z]
    cache[:x]
    cache.resize(5)
    expect(cache.to_hash).to match(
      x: 'x-ray',
      y: 'yankee',
      z: 'zulu'
    )
  end
end
