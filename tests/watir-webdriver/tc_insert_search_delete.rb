require 'watir-webdriver'
require 'test/unit'

Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }

class TestInsertSearchDelete < Test::Unit::TestCase

  include CaLogin

  def test_insert_search_delete
    b = Watir::Browser.new
    login_as 'http://providence.dev/', b, 'administrator', 'dublincore'

    b.link(:class => 'sf-with-ul').hover # open "New"
    b.link(:class => 'sf-with-ul', :index => 2).hover # open "Object"
    b.link(:text => 'Image').when_present.click # click on New > Object > Image

    # set idno
    b.text_field(id: 'idno_accession_number').clear
    b.text_field(id: 'idno_accession_number').set 'test123'

    # set title (there must be a better way to address them)
    b.textarea(index: 1).clear
    b.textarea(index: 1).set 'My new test image'

    # submit form
    b.form(:id => 'ObjectEditorForm').submit

    # Check if all went well
    unless b.text.include? 'Added Image'
      raise 'could not save object'
    end

    # go to dashboard
    b.div(id: 'logo').click

    b.text_field(:id, 'caQuickSearchFormText').clear
    b.text_field(:id, 'caQuickSearchFormText').send_keys "test123\n"

    assert b.title.include? 'Editing Image'
  end
end

