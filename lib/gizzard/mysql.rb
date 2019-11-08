module Gizzard
  module Mysql
    extend ActiveSupport::Concern

    included do
      scope :filtered_by, -> (column, value) do
        v = value.respond_to?(:strip) ? value.strip : value
        v.present? ? where(column => value) : all
      end

      scope :forward_matching_by, -> (column, value) { where("`#{table_name}`.`#{column}` LIKE ?", "#{sanitize_sql_like(value)}%") }
      scope :backward_matching_by, -> (column, value) { where("`#{table_name}`.`#{column}` LIKE ?", "%#{sanitize_sql_like(value)}") }
      scope :partial_matching_by, -> (column, value) { where("`#{table_name}`.`#{column}` LIKE ?", "%#{sanitize_sql_like(value)}%") }
    end

    class_methods do
      def order_by_field(column, values)
        values.present? ? order(Arel.sql("field(`#{table_name}`.`#{column}`, #{values.join(',')})")) : all
      end

      def order_by_id_field(ids)
        order_by_field(:id, ids)
      end

      def use_index(indexes)
        from("#{table_name} USE INDEX(#{Array(indexes).join(', ')})")
      end

      def force_index(indexes)
        from("#{table_name} FORCE INDEX(#{Array(indexes).join(', ')})")
      end

      def lock_in_share
        lock('LOCK IN SHARE MODE')
      end
    end

    def to_id
      id
    end

    def lock_in_share!
      lock!('LOCK IN SHARE MODE')
    end
  end
end
