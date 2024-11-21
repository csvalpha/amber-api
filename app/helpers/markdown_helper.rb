module MarkdownHelper
  include CamoHelper

  def camofy(markdown)
    return unless markdown

    markdown.gsub(markdown_img_regex) do
      "![#{Regexp.last_match(1)}](#{camo(Regexp.last_match(2))}#{Regexp.last_match(3)})"
    end

    markdown.gsub(html_img_regex) do
      quote_mark = Regexp.last_match(2)
      "<img#{Regexp.last_match(1)} src=#{quote_mark}#{camo(Regexp.last_match(3))}#{quote_mark}#{Regexp.last_match(4)}"
    end
  end

  def markdown_img_regex
    # ![alt text](url =widthxheight "title")
    /!\[([^\[]*)\]\(([^\ )]+)(( =[^)]?[^ ]+)?( [^)]?"[^)]+")?)?\)/
  end

  def html_img_regex
    # warning: this regex may not be perfect. They rarely are. If you find an edge case, improve this regex!
    # <img...something... src="url"
    # or, the alternative quotes: <img...something... src='url'
    # or, even without
    # note that we don't allow mismatched quotes like 'url" or shenanigans like that
    # This regex contains two particularly useful features:
    #  capturing groups, and lazy matching.
    /<img([^>]*) src=(["']?)(.+?)\2([ >])/
  end
end
