require 'rubygems'
require 'sqlite3'
require 'active_record'
require './lib/cuttable'
require 'byebug'
require 'minitest/autorun'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :users do |table|
    table.integer :postcode
  end
end

class User < ActiveRecord::Base
  include Cuttable
end

class TestCuttableSqlite < MiniTest::Unit::TestCase
  def setup
    5.times do |i|
      User.create(postcode: i)
    end
  end

  def test_includes_concern_to_model
    assert(User.last.id, User.sanitize_order('id DESC').first.id)
  end

  def test_multiple_columns
    sql = "SELECT \"#{User.table_name}\".* FROM \"#{User.table_name}\" ORDER BY postcode, id desc"
    assert_equal(sql, User.sanitize_order('postcode, id DESC').to_sql)
  end

  def test_single_column
    assert_equal(default_sql_query, User.sanitize_order('id DESC').to_sql)
  end

  def test_blind_sql_injection
    assert_equal(default_sql_query, User.sanitize_order('id, (select sleep(2000) from dual where database() like database())#').to_sql)
  end

  def test_cuts_off_other_than_the_real_column
    assert_equal(default_sql_query, User.sanitize_order('id, something desc').to_sql)
  end

  def test_sets_default_value_for_sort_by
    assert_equal(default_sql_query, User.sanitize_order('id, something').to_sql)
  end

  def default_sql_query
    "SELECT \"#{User.table_name}\".* FROM \"#{User.table_name}\" ORDER BY id desc"
  end

  def teardown
    User.delete_all
  end
end
