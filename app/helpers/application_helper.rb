# -*- coding: utf-8 -*-
module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        )
    markdown.render(text)
#    syntax_highlighter markdown.render(text)
  end

#重い
  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre/code[@class]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:class])
    end
    #TODO: Nokogiriが勝手にdoctype宣言をしてくるのを防ぐ
    doc.to_s.split(">", 2)[1]
  end
end
