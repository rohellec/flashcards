require 'open-uri'

VOCABULARY_URL = 'http://www.homeenglish.ru/250Popular.htm'
TABLE_XPATH = '//p[contains(text(), "250 самых популярных английских слов")]'\
              '/following-sibling::table[1]'
LINKS_XPATH = '//p[contains(text(), "250 самых популярных английских слов")]'\
              '/following-sibling::p[1]/a/@href'

def split(enum)
  result = [arr = []]
  enum.each do |obj|
    if yield(obj)
      result << (arr = []) unless arr.empty?
    else
      arr << obj
    end
  end
  result.pop if arr.empty?
  result
end

def words_from_table(table)
  result = []
  rows = table.xpath('tr')

  # trim the header of the table and iterate through the remaining rows
  rows[1..-1].each do |row|
    row_cells = row.xpath('td').map { |cell| cell.text.strip }

    # split the row into arrays either around the number or around the dash
    split(row_cells) { |cell| cell =~ /(\A\d+\Z) | (\A-\Z)/x }.each do |arr|
      result << arr
    end
  end
  result
end

def create_cards_from_table(table)
  words = words_from_table(table)

  # if translation part contains more then 1 dot it means that
  # it is not a translation, but grammar rule
  vocabulary = words.select { |original, translated| translated.count('.') <= 1 }

  vocabulary.each do |original, translated|
    # trim of transcription and verb tenses from original text
    md = original.match(/\w+/)
    original = md[0]

    # remove verb tenses and meaning counters from translated text
    translated = translated.gsub(/\d\)\s* | \([a-z\s,;]+\)\s*/x, '')

    Card.create!(original_text: original, translated_text: translated)
  end
end

def table_from_url(link, path)
  doc = Nokogiri::HTML(open(link)) { |config| config.noblanks }
  doc.xpath(path)
end

def full_url(defautl_url, rel)
  url = URI(defautl_url)
  "#{url.scheme}://#{url.host}/#{rel}"
end

Card.delete_all

# create cards from default url
table = table_from_url(VOCABULARY_URL, TABLE_XPATH)
create_cards_from_table(table)

# create cards from other urls on the page
doc = Nokogiri::HTML(open(VOCABULARY_URL)) { |config| config.noblanks }
link_nodes = doc.xpath(LINKS_XPATH)

link_nodes.each do |link_node|
  rel = link_node.text
  table = table_from_url(full_url(VOCABULARY_URL, rel), TABLE_XPATH)
  create_cards_from_table(table)
end
