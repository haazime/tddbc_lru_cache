RSpec.describe LRUCache, 'サイズを固定' do
  let(:cache) { LRUCache.new(2) }

  it '存在しないキーで取り出すとnilが返る' do
    expect(cache.get(:a)).to be_nil
  end

  it '何も消えない' do
    expect(cache.to_hash).to match({})
  end

  it '何も消えない' do
    cache.put(:a, 'alpha')
    expect(cache.to_hash).to match(
      a: 'alpha'
    )
  end

  it '何も消えない' do
    cache.put(:a, 'alpha')
    cache.put(:b, 'bravo')
    expect(cache.to_hash).to match(
      a: 'alpha',
      b: 'bravo',
    )
  end

  it ':aが消える' do
    cache.put(:a, 'alpha')
    cache.put(:b, 'bravo')
    cache.put(:c, 'charlie')
    expect(cache.to_hash).to match(
      b: 'bravo',
      c: 'charlie',
    )
  end

  it ':bが消える' do
    cache.put(:a, 'alpha')
    cache.put(:b, 'bravo')
    cache.get(:a)
    cache.put(:c, 'charlie')
    expect(cache.to_hash).to match(
      a: 'alpha',
      c: 'charlie',
    )
  end

  it ':aが消える' do
    cache.put(:a, 'alpha')
    cache.put(:b, 'bravo')
    cache.get(:a)
    cache.get(:b)
    cache.put(:c, 'charlie')
    expect(cache.to_hash).to match(
      b: 'bravo',
      c: 'charlie',
    )
  end
end

RSpec.describe LRUCache, 'サイズを5から2に変更' do
  let(:cache) { LRUCache.new(5) }

  before do
    cache.put(:a, 'alpha')
    cache.put(:b, 'bravo')
    cache.put(:c, 'charlie')
    cache.put(:d, 'delta')
    cache.put(:e, 'echo')
  end

  it ':a,:b,:cが消える' do
    cache.resize(2)
    expect(cache.to_hash).to match(
      d: 'delta',
      e: 'echo',
    )
  end

  it ':a,:b,:dが消える' do
    cache.get(:a)
    cache.get(:c)
    cache.get(:e)
    cache.resize(2)
    expect(cache.to_hash).to match(
      c: 'charlie',
      e: 'echo'
    )
  end

  it ':a,:b,:d,:cが消える' do
    cache.get(:a)
    cache.get(:c)
    cache.get(:e)
    cache.resize(2)
    cache.put(:f, 'foxtrot')
    expect(cache.to_hash).to match(
      e: 'echo',
      f: 'foxtrot'
    )
  end
end

RSpec.describe LRUCache, 'サイズを3から5に変更' do
  let(:cache) { LRUCache.new(3) }

  before do
    cache.put(:x, 'x-ray')
    cache.put(:y, 'yankee')
    cache.put(:z, 'zulu')
  end

  it '何も消えない' do
    cache.get(:z)
    cache.get(:x)
    cache.resize(5)
    expect(cache.to_hash).to match(
      x: 'x-ray',
      y: 'yankee',
      z: 'zulu'
    )
  end
end

RSpec.describe LRUCache, 'タイムアウトを60秒に設定' do
  let(:cache) { LRUCache.new(2, timeout: 60) }

  it '60秒以上経ったデータは消える' do
    stub_now(Time.now - 60) do
      cache.put(:a, 'alpha')
    end
    cache.put(:b, 'bravo')
    expect(cache.get(:a)).to be_nil
    expect(cache.get(:b)).to eq('bravo')
  end

  it '60秒経っていないデータは残る' do
    freezed_now = Time.now
    stub_now(freezed_now - 59) do
      cache.put(:x, 'x-ray')
      cache.put(:y, 'yankee')
      cache.put(:z, 'zulu')
    end
    stub_now(freezed_now) do
      expect(cache.get(:y)).to eq('yankee')
      expect(cache.get(:z)).to eq('zulu')
    end
  end
end
