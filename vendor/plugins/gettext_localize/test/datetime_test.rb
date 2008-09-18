require File.dirname(__FILE__) + '/test_helper'

class DatetimeTest < Test::Unit::TestCase
  include GettextLocalize

  def setup
    GettextLocalize.set_locale('ca_ES')
    @ca_abbr_daynames = ["Dg","Dl","Dt","Dc","Dj","Dv","Ds"]
    @ca_abbr_monthnames = ["Gen","Feb","Mar","Abr","Mai","Jun","Jul","Ago","Set","Oct","Nov","Des"]
    @ca_daynames = ["Diumenge","Dilluns","Dimarts","Dimecres","Dijous","Divendres","Dissabte"]
    @ca_monthnames = ["Gener","Febrer","Març","Abril","Maig","Juny","Juliol","Agost","Setembre","Octubre","Novembre","Desembre"]

    # ensure DATE_FORMATS not overwritten by app
    GettextLocalize.send(:class_variable_set, '@@formats', {})
    Time::DATE_FORMATS.replace({:short =>"%d %b %H:%M", :rfc822=>"%a, %d %b %Y %H:%M:%S %z", :long=>"%B %d, %Y %H:%M", :db=>"%Y-%m-%d %H:%M:%S"})
    Date::DATE_FORMATS.replace({:short=>"%e %b", :long=>"%B %e, %Y"})
    DateTime::DATE_FORMATS.replace({:short=>"%e %b", :long=>"%B %e, %Y"})
  end

  def test_daynames

    (1..7).each do |d|
      assert_equal @ca_abbr_daynames[d-1],Date.new(2006,12,23+d).strftime("%a")
      assert_equal @ca_abbr_daynames[d-1],Time.mktime(2006,12,23+d,0,0,0,0).strftime("%a")
      assert_equal @ca_abbr_daynames[d-1],DateTime.new(2006,12,23+d,0,0,0,0).strftime("%a")
      assert_equal @ca_daynames[d-1],Date.new(2006,12,23+d).strftime("%A")
      assert_equal @ca_daynames[d-1],Time.mktime(2006,12,23+d,0,0,0,0).strftime("%A")
      assert_equal @ca_daynames[d-1],DateTime.new(2006,12,23+d,0,0,0,0).strftime("%A")
    end


  end

  def test_monthnames

    (1..12).each do |m|
      assert_equal @ca_abbr_monthnames[m-1],Date.new(2006,m,23).strftime("%b")
      assert_equal @ca_abbr_monthnames[m-1],Time.mktime(2006,m,23,0,0,0,0).strftime("%b")
      assert_equal @ca_abbr_monthnames[m-1],DateTime.new(2006,m,23,0,0,0,0).strftime("%b")
      assert_equal @ca_monthnames[m-1],Date.new(2006,m,23).strftime("%B")
      assert_equal @ca_monthnames[m-1],Time.mktime(2006,m,23,0,0,0,0).strftime("%B")
      assert_equal @ca_monthnames[m-1],DateTime.new(2006,m,23,0,0,0,0).strftime("%B")
    end

  end

  def test_method_to_s

    pdate = Date.new(2006,12,24)
    ptime = Time.local(2006,12,24,0,0,0,0)
    pdatetime = DateTime.new(2006,12,24,0,0,0,0)

    assert_equal "24-12-2006", pdate.to_s
    assert_equal "Dg 24 Des 00:00:00 CET 2006", ptime.to_s
    assert_equal "Dg 24 Des 00:00:00 2006", pdatetime.to_s

    assert_equal "2006-12-24", pdate.to_s(:default, true)
    assert_equal "Sun Dec 24 00:00:00 CET 2006", ptime.to_s(:default, true)
    assert_equal "Sun Dec 24 00:00:00 2006", pdatetime.to_s(:default, true)

    assert_equal "24 de Desembre, 2006", pdate.to_s(:long)
    assert_equal "24 Des", pdate.to_s(:short)

    assert_equal "24 de Desembre, 2006 00:00", ptime.to_s(:long)
    assert_equal "24 Des 00:00", ptime.to_s(:short)
    assert_equal "2006-12-24 00:00:00",ptime.to_s(:db)

    assert_equal "24 de Desembre, 2006", pdatetime.to_s(:long)
    assert_equal "24 Des", pdatetime.to_s(:short)


    GettextLocalize.set_locale('en_US')

    assert_equal "2006-12-24",pdate.to_s
    assert_equal "Sun Dec 24 00:00:00 CET 2006",ptime.to_s
    assert_equal "Sun Dec 24 00:00:00 2006",pdatetime.to_s

    assert_equal "2006-12-24", pdate.to_s(:default, true)
    assert_equal "Sun Dec 24 00:00:00 CET 2006", ptime.to_s(:default, true)
    assert_equal "Sun Dec 24 00:00:00 2006", pdatetime.to_s(:default, true)

    assert_equal "December 24, 2006", pdate.to_s(:long)
    assert_equal "24 Dec", pdate.to_s(:short)

    assert_equal "December 24, 2006 00:00", ptime.to_s(:long)
    assert_equal "24 Dec 00:00", ptime.to_s(:short)
    assert_equal "2006-12-24 00:00:00",ptime.to_s(:db)

    assert_equal "December 24, 2006", pdatetime.to_s(:long)
    assert_equal "24 Dec", pdatetime.to_s(:short)

    GettextLocalize.set_locale('es_ES')

    assert_equal "24-12-2006",pdate.to_s
    assert_equal "Dom Dic 24 00:00:00 CET 2006",ptime.to_s
    assert_equal "Dom Dic 24 00:00:00 2006",pdatetime.to_s

    assert_equal "2006-12-24", pdate.to_s(:default, true)
    assert_equal "Sun Dec 24 00:00:00 CET 2006", ptime.to_s(:default, true)
    assert_equal "Sun Dec 24 00:00:00 2006", pdatetime.to_s(:default, true)

    assert_equal "24 de Diciembre, 2006", pdate.to_s(:long)
    assert_equal "24 Dic", pdate.to_s(:short)

    assert_equal "24 de Diciembre, 2006 00:00", ptime.to_s(:long)
    assert_equal "24 Dic 00:00", ptime.to_s(:short)
    assert_equal "2006-12-24 00:00:00",ptime.to_s(:db)

    assert_equal "24 de Diciembre, 2006", pdatetime.to_s(:long)
    assert_equal "24 Dic", pdatetime.to_s(:short)
  end

  def test_method_strftime

    pdate = Date.new(2006,12,24)
    ptime = Time.mktime(2006,12,24,0,0,0,0)
    pdatetime = DateTime.new(2006,12,24,0,0,0,0)

    assert_equal "24-12-2006", pdate.strftime("%d-%m-%Y")
    assert_equal "Dg Des 24 00:00:00 CET 2006", ptime.strftime("%a %b %d %H:%M:%S %Z %Y")
    assert_equal "Dg Des 24 00:00:00 2006", pdatetime.strftime("%a %b %d %H:%M:%S %Y")

    GettextLocalize.set_locale('en_US')

    assert_equal "24-12-2006", pdate.strftime("%d-%m-%Y")
    assert_equal "Sun Dec 24 00:00:00 CET 2006", ptime.strftime("%a %b %d %H:%M:%S %Z %Y")
    assert_equal "Sun Dec 24 00:00:00 2006", pdatetime.strftime("%a %b %d %H:%M:%S %Y")

    GettextLocalize.set_locale('es_ES')

    assert_equal "24-12-2006", pdate.strftime("%d-%m-%Y")
    assert_equal "Dom Dic 24 00:00:00 CET 2006", ptime.strftime("%a %b %d %H:%M:%S %Z %Y")
    assert_equal "Dom Dic 24 00:00:00 2006", pdatetime.strftime("%a %b %d %H:%M:%S %Y")

  end

end
