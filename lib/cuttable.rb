module Cuttable
  extend ActiveSupport::Concern
  module ClassMethods
    def sanitize_order(sql)
      return order(@@default_order) if sql.to_s.empty?
      values = (sql || 'id desc').downcase.strip.split(/ |, /)
      sort_by = values.slice!(-1)
      return order(@@default_order) unless %w[asc desc].include?(sort_by) &&
                                    (values - column_names).empty?
      query = values.join(', ') + " #{sort_by}"
      order(query)
    end

    def default_order(query)
      @@default_order = query
    end
  end
end
