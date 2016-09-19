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
                    trx_type: seq>7 ? 'new' : 'second')
  end

  # old
  def compute_transactions
    today=(Time.now.utc+60*60*8).to_date.to_s
    news=fetch_statistics
    had=Transaction.find_by(trx_date: today)
    if had
      news.each do |tx|
        cur=Transaction.find_by(trx_date: today,district: tx.district, trx_type: tx.trx_type)
        next unless cur
        new_tx=tx.diff(cur)
        new_tx ? new_tx.save : cur.touch&&cur.save
      end
    else
      news.each{|tx| tx.save}
    end
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

HouseListener.new.compute_transactions
