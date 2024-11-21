module MarkdownHelper
  include CamoHelper

  def camofy(text)
    return unless text

    text = sub_markdown(text)
    sub_html(text)
  end

  def sub_markdown(text)
    text.gsub(markdown_img_regex) do
      "![#{Regexp.last_match(1)}](#{camo(Regexp.last_match(2))}#{Regexp.last_match(3)})"
    end
  end

  def sub_html(text)
    text.gsub(html_img_regex) do
      preceding_src = Regexp.last_match(1)
      quote_mark = Regexp.last_match(2)
      url = Regexp.last_match(3)
      ending = Regexp.last_match(4)
      "<img#{preceding_src} src=#{quote_mark}#{camo(url)}#{quote_mark}#{ending}"
    end
  end

  def markdown_img_regex
    # ![alt text](url =widthxheight "title")
    /!\[([^\[]*)\]\(([^\ )]+)(( =[^)]?[^ ]+)?( [^)]?"[^)]+")?)?\)/
  end

  def html_img_regex
    # warning: this regex may not be perfect. They rarely are.
    # If you find an edge case, improve this regex!
    # <img...something... src="url"...ending...
    # or, the alternative quotes: <img...something... src='url'...ending...
    # or, even without quotes: <img...something... src=url...ending...
    # and the ...ending... can be either a space, a > or />
    # note that we don't allow mismatched quotes like 'url" or shenanigans like that
    # This regex contains two particularly useful features:
    #  capturing groups, and lazy matching.
    %r{<img([^>]*) src=(["']?)(.+?)\2( |>|/>)}
  end
end
