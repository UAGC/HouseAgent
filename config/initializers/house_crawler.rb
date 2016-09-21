require 'nokogiri'
require 'open-uri'

class HouseCrawler
  QUERY_URL = 'http://www.cdfgj.gov.cn/SCXX/Default.aspx'.freeze

  def crawl_statistics
    html = Nokogiri::HTML(open(QUERY_URL).read)
    res = html.css('.blank tr').children.map { |item| item.text.gsub!(/[\r|\n| ]/, '') }.reject { |item| item.empty? || item.ord == 160 }
    arr = (0...res.length / 4).to_a.map { |i| res[i * 4..i * 4 + 3] }
    ((1..6).to_a + (8..13).to_a).map { |i| obj(arr[i], i) }
  end

  def find_tx!(coming)
    coming.each do |tx|
      have = Transaction.find_by(trx_date: tx.trx_date, district: tx.district, trx_type: tx.trx_type)
      return unless have
      found = tx.separate(have)
      found.save if found.is_a? Transaction
    end
  end

  def update_statistics(coming)
    had = Transaction.where(trx_date: coming[0].trx_date, trx_type: 'stx_new') + Transaction.where(trx_date: coming[0].trx_date, trx_type: 'stx_second')
    had.each(&:destroy)
    coming.each(&:save)
    stx = Transaction.where(trx_date: coming[0].trx_date, trx_type: 'stx_city_new') +
        Transaction.where(trx_date: coming[0].trx_date, trx_type: 'stx_city_second') +
        Transaction.where(trx_date: coming[0].trx_date, trx_type: 'stx_city_all')
    stx.each(&:destroy)
    group=coming.group_by(&:trx_type).map { |_, v| reduce_stx(v) }
    all=reduce_stx(group)
    all.trx_type='stx_city_all'
    (group+[all]).each(&:save)
  end

  def check!
    puts "starting check House Market"
    coming = crawl_statistics
    find_tx!(coming)
    update_statistics(coming)
  end

  private

  def reduce_stx(txs)
    Transaction.new(trx_date: txs[0].trx_date,
                    district: '成都市',
                    total_area: txs.map(&:total_area).reduce(:+),
                    rcount: txs.map(&:rcount).reduce(:+),
                    resident_area: txs.map(&:resident_area).reduce(:+),
                    trx_type: 'stx_city_'+txs[0].trx_type[4..-1])
  end

  def obj(item, seq)
    Transaction.new(district: item[0],
                    total_area: (item[1].to_f * 100).to_i,
                    rcount: item[2].to_i,
                    resident_area: (item[3].to_f * 100).to_i,
                    trx_date: (Time.now.utc + 60 * 60 * 8).to_date.to_s,
                    trx_type: seq < 7 ? 'stx_new' : 'stx_second')
  end
end
