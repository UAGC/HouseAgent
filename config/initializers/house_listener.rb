require 'nokogiri'
require 'open-uri'

class HouseListener
  def initialize
    @query_url='http://www.cdfgj.gov.cn/SCXX/Default.aspx'
  end

  def fetch_statistics
    html=Nokogiri::HTML(open(@query_url).read)
    res=html.css(".blank tr").children.map{|item| item.text.gsub!(/[\r|\n| ]/,'')}.reject{|item| item.length==0 || item.ord==160}
    arr=(0...res.length/4).to_a.map{|i| res[i*4..i*4+3]}
    ((1..6).to_a+(8..13).to_a).map{|i| obj(arr[i],i)}
  end

  def obj(item, seq)
    Transaction.new(district: item[0], 
                    total_area: (item[1].to_f*100).to_i,
                    rcount: item[2].to_i,
                    resident_area: (item[3].to_f*100).to_i,
                    trx_date: (Time.now.utc+60*60*8).to_date.to_s,
                    trx_type: seq<7 ? 'new' : 'second')
  end

  # old
  def compute_transactions
    today=(Time.now.utc+60*60*8).to_date.to_s
    had=Transaction.where(trx_date: today, trx_type: 'stx_new')+Transaction.where(trx_date: today, trx_type: 'stx_second')
    news=fetch_statistics
    news.each { |i| puts "#{i.trx_date} #{i.total_area} #{i.trx_type}"}
    if had.any?
      news.each do |tx|
        cur=Transaction.find_by!(trx_date: today,district: tx.district, trx_type: 'stx_'+tx.trx_type)
        item = tx.separate(cur)
        puts "tx --> type:#{tx.trx_type}"
        puts "cur --> type:#{cur.trx_type}"
        puts "news--type:#{item.trx_type}" if item&.is_a?(Transaction)
        item&.is_a?(Transaction) ? item.save : (cur.touch&&cur.save && puts(" -------invalid item");)
      end
    else
      news.each do |tx| 
        tx.trx_type='stx_'+tx.trx_type
        tx.save
      end
    end
    had.each{|t| t.destroy} if news.first.trx_date==today
  end

  def listen
    i=0
    loop do
      i+=1
      puts " *** *** ***"
      puts "-- #{i} th action: Listen for new Transaction"
      puts " *** *** ***"
      compute_transactions
      sleep 60
    end
  end
  def collect
  end
end

#HouseListener.new.compute_transactions
