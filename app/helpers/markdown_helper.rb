module MarkdownHelper
  include CamoHelper

  def camofy(markdown)
    return unless markdown

    markdown.gsub(markdown_img_regex) do
      "![#{Regexp.last_match(1)}](#{camo(Regexp.last_match(2))}#{Regexp.last_match(3)})"
    end
  end

  def markdown_img_regex
    # ![alt text](url =widthxheight "title")
    /!\[([^\[]*)\]\(([^\ )]+)(( =[^\)]?[^ ]+)?( [^\)]?"[^)]+")?)?\)/
  end
end
