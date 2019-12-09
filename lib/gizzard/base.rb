module Gizzard
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def less_than_id(id)
        less_than(:id, id)
      end

      def greater_than_id(id)
        greater_than(:id, id)
      end

      def less_than(key, value)
        value.present? ? all.where(arel_table[key].lt(value)) : all
      end

      def less_than_equal(key, value)
        value.present? ? all.where(arel_table[key].lteq(value)) : all
      end

      def greater_than(key, value)
        value.present? ? all.where(arel_table[key].gt(value)) : all
      end

      def greater_than_equal(key, value)
        value.present? ? all.where(arel_table[key].gteq(value)) : all
      end
    end
  end
end
