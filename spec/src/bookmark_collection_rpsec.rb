require 'spec_helper'

describe Alfmarks::BookmarkCollection do

  describe '#to_xml' do

    context 'given no nodes' do

      subject { Alfmarks::BookmarkCollection.new([]) }

      it 'returns empty xml document' do
        expect(subject.to_xml).to eq('abc')
      end

    end

    context 'given one nodes' do

      let(:node) { Alfmarks::BookmarkModel.new.stub(:to_xml).and_return('<item />') }

      subject { Alfmarks::BookmarkCollection.new([node]) }

      it 'calls to xml on nodes' do
        expect(node).to have_received(:to_xml)
      end

    end

  end

end
