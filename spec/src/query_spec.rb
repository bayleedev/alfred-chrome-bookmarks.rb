require 'spec_helper'

describe Alfmarks::Query do

  subject { Alfmarks::Query.new(:model => 'foo', :term => 'bar') }

  describe '#model' do
    it { expect(subject.model).to eq('foo') }
  end

  describe '#term' do
    it { expect(subject.term).to eq(/bar/i) }
  end

end
