module PayPal::SDK::REST
  describe ErrorHash do
    it 'converts Hashes to ErrorHashes' do
      hash = ErrorHash.convert({
        nested_hash: { bing: 'bong' },
        empty_array: [],
        array_with_hashes: [
          { foo: 'boo' },
          { biz: 'boz' }
        ],
        array_without_hashes: [1, 2, 3],
        nilly: nil,
        stringy: 'cheese'
      })

      expect(hash).to be_a(ErrorHash)
      expect(hash.nested_hash).to be_a(ErrorHash)
      expect(hash.empty_array).to eq([])
      expect(hash.array_with_hashes[0]).to be_a(ErrorHash)
      expect(hash.array_with_hashes[1]).to be_a(ErrorHash)
      expect(hash.array_without_hashes).to eq([1, 2, 3])
      expect(hash.nilly).to be_nil
      expect(hash.stringy).to eq('cheese')
    end

    it 'can access string keys as properties, strings, or symbols' do
      hash = ErrorHash.convert({ 'foo' => 5 })
      hash['boo'] = 'grue'

      expect(hash.foo).to eq(5)
      expect(hash['foo']).to eq(5)
      expect(hash[:foo]).to eq(5)
      expect(hash.boo).to eq('grue')
      expect(hash['boo']).to eq('grue')
      expect(hash[:boo]).to eq('grue')
    end

    it 'can access symbol keys as properties, strings, or symbols' do
      hash = ErrorHash.convert({ :foo => 5 })
      hash[:boo] = 'grue'

      expect(hash.foo).to eq(5)
      expect(hash['foo']).to eq(5)
      expect(hash[:foo]).to eq(5)
      expect(hash.boo).to eq('grue')
      expect(hash['boo']).to eq('grue')
      expect(hash[:boo]).to eq('grue')
    end

    it 'converts Hashes to ErrorHashes on assignment' do
      hash = ErrorHash.new
      hash['foo'] = { bing: 'bong' }

      expect(hash['foo']).to be_a(ErrorHash)
      expect(hash['foo'].bing).to eq('bong')
    end

    it 'converts Hashes inside of Arrays to ErrorHashes on assignment' do
      hash = ErrorHash.new
      hash['foo'] = [{ bing: 'bong' }]

      expect(hash['foo'][0]).to be_a(ErrorHash)
      expect(hash['foo'][0].bing).to eq('bong')
    end

    it "doesn't convert Hashes inside of Arrays if the first element of the array isn't a Hash" do
      hash = ErrorHash.new
      hash['foo'] = [100, { bing: 'bong' }]

      expect(hash['foo'][1]).to be_a(Hash)
      expect(hash['foo'][1]).not_to be_a(ErrorHash)
    end

    it 'gets and sets numbers and strings' do
      hash = ErrorHash.new
      hash['foo'] = 123
      hash['boo'] = 'baa'

      expect(hash['foo']).to eq(123)
      expect(hash['boo']).to eq('baa')
    end
  end
end
