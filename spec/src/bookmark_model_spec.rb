require 'spec_helper'

describe Alfmarks::BookmarkModel do

  describe '#to_xml' do

    subject {
      Alfmarks::BookmarkModel.new(
        :id => 10,
        :name => 'Google',
        :url => 'http://google.com'
      )
    }

    let(:uid_first) {
      "<item uid='10' arg='http://google.com'>" +
        '<title>Google</title>' +
        '<subtitle>http://google.com</subtitle>' +
        '</item>'
    }

    let(:arg_first) {
      "<item arg='http://google.com' uid='10'>" +
        '<title>Google</title>' +
        '<subtitle>http://google.com</subtitle>' +
        '</item>'
    }

    # TODO this is kinda nasty
    # Basically REXML returns the args in a random
    # order. This has the two cases. It's hard to find
    # a xml comparer that works in 1.8.7
    it 'sets counter to 0' do
      expect([uid_first, arg_first]).to include(subject.to_xml.to_s)
    end

  end

end
