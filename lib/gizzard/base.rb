module Gizzard
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def preload_associations(records:, associations:, scope: nil)
        records = Array(records)
        return if records.empty?

        ActiveRecord::Associations::Preloader.new(records: records, associations: associations, scope: scope).call
      end

      def delete_all_by_id(batch_size: 1000)
        ids = pluck(:id)
        ids.sort!
        ids.each_slice(batch_size) do |chunked_ids|
          # unscoped入れないと既に適用されているスコープが引き継がれる
          unscoped.all.where(id: chunked_ids).delete_all
        end
      end

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
