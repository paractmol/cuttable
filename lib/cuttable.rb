module Cuttable
  extend ActiveSupport::Concern
  module ClassMethods
    def sanitize_order(sql = 'id desc')
      values = sql.downcase.strip.split(/ |, /)
      sort_by = values.slice!(-1)
      return order('id desc') unless %w[asc desc].include?(sort_by) &&
                                     (values - column_names).empty?
      query = values.join(', ') + " #{sort_by}"
      order(query)
    end
  end
end
