require 'open-uri'

VOCABULARY_URL = 'http://www.homeenglish.ru/250Popular.htm'
TABLE_XPATH = '//p[contains(text(), "250 самых популярных английских слов")]'\
              '/following-sibling::table[1]'
TABLE_NAME  = 'Популярные слова'
LINKS_XPATH = '//p[contains(text(), "250 самых популярных английских слов")]'\
              '/following-sibling::p[1]/a/@href'

def create_cards_from_table(table, deck)
  return if deck.nil?
  table.xpath('tr').each do |tr|
    [[2, 3], [5, 6]].each do |i, j|
      original   = tr.xpath("td[#{i}]").text.strip
      translated = tr.xpath("td[#{j}]").text.strip

      # if string from original is a word
      # and translated text doesn't contain any grammar rule
      if (original =~ /\w+/) && (translated.count('.') <= 1)
        # replace original text with the part that matched the pattern
        original = $&

        # remove value counters and verb tenses from translated text
        translated.gsub!(/\d\)\s* | \([a-z\s,;]+\)\s*/x, '')

        deck.cards.create!(original_text: original, translated_text: translated)
      end
    end
  end
end

def table_from_url(link, path)
  doc = Nokogiri::HTML(open(link), &:noblanks)
  doc.xpath(path)
end

def full_url(defautl_url, rel)
  url = URI(defautl_url)
  "#{url.scheme}://#{url.host}/#{rel}"
end

# adding example user or using existing one
user = User.find_by(email: "john.doe@example.com")
user ||= User.create(email: "john.doe@example.com", password: "foobar", password_confirmation: "foobar")

user.decks.delete_all
deck = user.decks.create(name: TABLE_NAME)

# create cards from default url
table = table_from_url(VOCABULARY_URL, TABLE_XPATH)
create_cards_from_table(table, deck)

# create cards from other urls on the page
doc = Nokogiri::HTML(open(VOCABULARY_URL), &:noblanks)
link_nodes = doc.xpath(LINKS_XPATH)

link_nodes.each do |link_node|
  rel = link_node.text
  table = table_from_url(full_url(VOCABULARY_URL, rel), TABLE_XPATH)
  create_cards_from_table(table, deck)
end
