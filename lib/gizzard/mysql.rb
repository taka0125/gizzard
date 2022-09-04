module Gizzard
  module Mysql
    extend ActiveSupport::Concern

    included do
      include Base

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

      def joins_with_use_index(relation_name, indexes)
        joins_with_index_hint(relation_name, indexes, join_type: :inner_join, hint: :use)
      end

      def joins_with_force_index(relation_name, indexes)
        joins_with_index_hint(relation_name, indexes, join_type: :inner_join, hint: :force)
      end

      def left_outer_joins_with_use_index(relation_name, indexes)
        joins_with_index_hint(relation_name, indexes, join_type: :left_outer_join, hint: :use)
      end

      def left_outer_joins_with_force_index(relation_name, indexes)
        joins_with_index_hint(relation_name, indexes, join_type: :left_outer_join, hint: :force)
      end

      def lock_in_share
        lock('LOCK IN SHARE MODE')
      end

      private

      def joins_with_index_hint(relation_name, indexes, join_type: :inner_join, hint: :use)
        relation = reflections[relation_name.to_s]
        join_table_name = relation.klass.table_name

        join = case join_type
               when :inner_join
                 'INNER JOIN'
               when :left_outer_join
                 'LEFT OUTER JOIN'
               else
                 raise
               end

        index_hint = case hint
                     when :use
                       'USE INDEX'
                     when :force
                       'FORCE INDEX'
                     else
                       raise
                     end

        c = connection
        joins <<-SQL
        #{join} #{c.quote_table_name(join_table_name)} #{index_hint}(#{Array(indexes).join(', ')}) ON #{c.quote_table_name(table_name)}.#{c.quote_column_name(relation.association_primary_key)} = #{c.quote_table_name(join_table_name)}.#{c.quote_column_name(relation.foreign_key)}
        SQL
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
