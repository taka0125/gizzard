module Gizzard
  module Mysql
    extend ActiveSupport::Concern

    included do
      include Base
    end

    class_methods do
      def filtered_by(column, value)
        v = value.respond_to?(:strip) ? value.strip : value
        return where(column => v) if v.present?

        all
      end

      def forward_matching_by(column, value, collate: nil)
        pattern = "#{sanitize_sql_like(value)}%"
        like_by(column, pattern, collate: collate)
      end

      def backward_matching_by(column, value, collate: nil)
        pattern = "%#{sanitize_sql_like(value)}"
        like_by(column, pattern, collate: collate)
      end

      def partial_matching_by(column, value, collate: nil)
        pattern = "%#{sanitize_sql_like(value)}%"
        like_by(column, pattern, collate: collate)
      end

      def order_by_field(column, values)
        return in_order_of(column, values) unless values.empty?

        all
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

      def like_by(column, sanitized_pattern, collate: nil)
        return where(arel_table[column].matches(sanitized_pattern)) if collate.blank?

        where(
          Arel.sql("`#{arel_table.name}`.`#{arel_table[column].name}` LIKE ? COLLATE #{collate}"),
          sanitized_pattern
        )
      end

      def joins_with_index_hint(relation_name, indexes, join_type: :inner_join, hint: :use)
        relation = reflections[relation_name.to_s]
        join_table_name = relation.klass.table_name

        join = case join_type
               when :inner_join
                 'INNER JOIN'
               when :left_outer_join
                 'LEFT OUTER JOIN'
               else
                 raise "Invalid join_type = #{join_type}"
               end

        index_hint = case hint
                     when :use
                       'USE INDEX'
                     when :force
                       'FORCE INDEX'
                     else
                       raise "Invalid hint = #{hint}"
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
