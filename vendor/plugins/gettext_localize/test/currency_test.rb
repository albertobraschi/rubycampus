require File.dirname(__FILE__) + '/test_helper'

class CurrencyTest < Test::Unit::TestCase
  include GettextLocalize
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

  def setup
    GettextLocalize.set_locale('ca_ES')
    @ca_months = ["Gener","Febrer","Març","Abril","Maig","Juny","Juliol","Agost","Setembre","Octubre","Novembre","Desembre"]
  end
  
  def parse_html_selects(html)
    data = []
    html.gsub!(Regexp.new("\n*</select>\n*$",Regexp::MULTILINE),"")
    selects = html.split(Regexp.new("(</select>)?\n*<select[^>]*>",Regexp::MULTILINE))
    selects.map!{|v| v.strip }
    selects.delete_if{|v| v.empty? }
    selects.each do | select |
      subdata = {}
      options = select.split(Regexp.new("\n*</option>\n*",Regexp::MULTILINE))
      data << options.map do | option |
        m = option.match(/<option value="([^"]*)">([^<]*)/)
        [m[2],m[1]]
      end
      
    end
    return data
  end

  def test_country_options
    countries_yml_file = Pathname.new(File.join(GettextLocalize.get_plugin_dir(),"countries.yml")).realpath.to_s
    countries = YAML::load(File.open(countries_yml_file))
    GettextLocalize.set_country_options	
    country_options = GettextLocalize.get_country_options
    assert_equal country_options, GettextLocalize.string_to_sym(countries["es"])
  end

  def test_number_to_currency
    num = number_to_currency(1234567.8945)
    assert_equal "1.234.567,89 €", num
    num = number_to_currency(1234567.8945,{:unit=>"%",:separator=>":",:delimiter=>"-",:order=>["unit","number"]})
    assert_equal "%1-234-567:89", num
    GettextLocalize.set_locale("en_US")
    num = number_to_currency(1234567.8945)
    assert_equal "$1,234,567.89", num
  end

  def test_select_date
    html = select_date(nil)
    data = parse_html_selects(html)
    
    days = []
    (1..31).each{|d| days << [d.to_s, d.to_s]}
    assert_equal days, data[0]
    
    months = []
    @ca_months.each_index{|k| months << [@ca_months[k], (k+1).to_s] }
    assert_equal months, data[1]
    
    years = []
    y = Time.now.year.to_i
    (y-5..y+5).each{|y| years << [y.to_s, y.to_s]}
    assert_equal years, data[2]
    
  end

  def test_select_datetime
    html = select_datetime(nil)
    data = parse_html_selects(html)
    
    days = []
    (1..31).each{|d| days << [d.to_s, d.to_s]}
    assert_equal days, data[0]
    
    months = []
    @ca_months.each_index{|k| months << [@ca_months[k], (k+1).to_s] }
    assert_equal months, data[1]
    
    years = []
    y = Time.now.year.to_i
    (y-5..y+5).each{|y| years << [y.to_s, y.to_s]}
    assert_equal years, data[2]
    
    hours = []
    (0..23).each{|h| h = "%02d" % h; hours <<[h,h]}
    assert_equal hours, data[3]
    
    minutes = []
    (0..59).each{|m| m = "%02d" % m; minutes <<[m,m]}
    assert_equal minutes, data[4]
  end

  def test_array_to_sentence
    a = [1,2,3,4,5,6]
    assert_equal "1, 2, 3, 4, 5 i 6", a.to_sentence(:skip_last_comma => true)
    assert_equal "1, 2, 3, 4, 5, i 6", a.to_sentence(:skip_last_comma => false)
    assert_equal "1, 2, 3, 4, 5 ju 6", a.to_sentence(:skip_last_comma => true,:connector => "ju")
    assert_equal "1, 2, 3, 4, 5, ju 6", a.to_sentence(:skip_last_comma => false,:connector => "ju")
    GettextLocalize.set_locale("en_US")
    assert_equal "1, 2, 3, 4, 5 and 6", a.to_sentence(:skip_last_comma => true)
    assert_equal "1, 2, 3, 4, 5, and 6", a.to_sentence(:skip_last_comma => false)
  end

end
