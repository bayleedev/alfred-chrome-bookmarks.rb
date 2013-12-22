require 'rexml/document'
require 'rexml/element'
require 'json'

module Alfmarks

  # Owns all of the bookmarks
  class BookmarkCollection
    attr_accessor :nodes

    def initialize(nodes)
      @nodes = nodes
    end

    def to_xml
      document = REXML::Document.new('<?xml version="1.0"?>')
      items = document.add_element('items')
      nodes.each do |node|
        items << node.to_xml
      end
      document.to_s
    end

  end

  # Responsible for holding a single bookmark
  class BookmarkModel
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def to_xml
      item = REXML::Element.new('item')
      item.add_attribute('arg', data[:url])
      item.add_attribute('uid', data[:id])
      item.add_element('title').text = data[:name]
      item.add_element('subtitle').text = data[:url]
      item
    end

    # Responsible for sending a query object to Source
    def self.find(term)
      data = Source.new.read(Query.new(:term => term, :model => self))
      BookmarkCollection.new(data)
    end

  end

  # Responsible for gathering data, normalizing it and
  # putting into model instances.
  class Source

    # TODO add bookmarks.json to a config
    def read(query)
      normalize(Json.from_file('./bookmarks.json')) do |obj|
        if obj.is_a?(Hash) && obj.values.grep(query.term).size > 0
          query.model.new(
            :id => obj['id'],
            :url => obj['url'],
            :name => obj['name']
          )
        else
          nil
        end
      end
    end

    # Recursively iterates `obj` adding every block return
    # value to `nodes`.
    def normalize(obj, &block)
      nodes = []
      nodes << block.call(obj)
      obj.each do |k,v|
        value = v || k
        if value.is_a?(Enumerable) and !value.is_a?(String)
          nodes += normalize(value, &block)
        end
      end
      nodes.compact
    end

  end

  # Very basic, but could eventually have items
  # such as limit, join, skip, etc.
  class Query
    attr_accessor :model
    attr_accessor :term

    def initialize(obj)
      @model = obj[:model] if obj[:model]
      @term = obj[:term] if obj[:term]
    end

    def term
      ::Regexp.new(@term, 'i')
    end

  end

  class Json
    # Loads json from a file and returns it
    def self.from_file(filename)
      ::File.open(filename, 'r') do |f|
        ::JSON.load(f)
      end
    end
  end

end
