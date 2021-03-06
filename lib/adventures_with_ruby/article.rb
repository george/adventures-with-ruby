# encoding: UTF-8
module AdventuresWithRuby
  class Article < Struct.new(:id, :metadata)
    include Comparable

    def <=>(other)
      other.published_at <=> published_at
    end

    def old?
      !deprecated? && published_at < (Date.today - 500)
    end

    def deprecated?
      metadata['deprecated']
    end

    def published_at
      metadata['publish']
    end

    def disqus_id
      metadata['wp'] ? "#{metadata['wp']} http://iain.nl/?p=#{metadata['wp']}" : id
    end

    def title
      metadata['title']
    end

    def summary
      metadata['summary']
    end

    def contents
      @contents ||= Contents.new(id)
    end

    def found?
      metadata
    end

    def url
      "/#{id}"
    end

  end
end
