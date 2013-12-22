require 'spec_helper'

describe Alfmarks::Source do

  describe '#read' do

    let(:results) { [
      {'id' => 1, 'name' => 'Google', 'url' => 'http://google.com'},
      {'id' => 2, 'name' => 'Gmail', 'url' => 'http://mail.google.com'},
      {'id' => 3, 'name' => 'Yahoo!', 'url' => 'http://yahoo.com'}
    ] }

    let(:query) {
      Alfmarks::Query.new(
        :model => Alfmarks::BookmarkModel,
        :term => 'Goo'
      )
    }

    before do
      Alfmarks::Json.stub(:from_file).and_return(results)
    end

    it 'returns both google results' do
      result = subject.read(query)

      expect(result.length).to eq(2)
      expect(result[0].data).to eq(
        :id => 1,
        :name => 'Google',
        :url => 'http://google.com'
      )
      expect(result[1].data).to eq(
        :id => 2,
        :name => 'Gmail',
        :url => 'http://mail.google.com'
      )
    end

  end

  describe '#normalize' do

    it 'should return single item array' do
      expect(subject.normalize([1,2]) { 'yes' }).to eq(['yes'])
    end

  end

end
