# https://www.periscopedata.com/blog/medians-in-sql.html
module DatabaseMedian
  extend ActiveSupport::Concern

  def median_datetime(arel_table, query_so_far, column_sym)
    case ActiveRecord::Base.connection.adapter_name
    when 'PostgreSQL'
      pg_median_datetime(arel_table, query_so_far, column_sym)
    when 'Mysql2'
      mysql_median_datetime(arel_table, query_so_far, column_sym)
    else
      raise NotImplementedError, "We haven't implemented a database median strategy for your database type."
    end
  end

  def mysql_median_datetime(arel_table, query_so_far, column_sym)
    query = arel_table.
            from(arel_table.project(Arel.sql('*')).order(arel_table[column_sym]).as(arel_table.table_name)).
            project(Arel::Nodes::NamedFunction.new("AVG", [arel_table[column_sym]]).as('median')).
            where(Arel::Nodes::Between.new(Arel.sql("(select @row_id := @row_id + 1)"),
                                           Arel::Nodes::And.new([Arel.sql('@ct/2.0'),
                                                                 Arel.sql('@ct/2.0 + 1')]))).
            # Disallow negative values
            where(arel_table[column_sym].gteq(0))

    [Arel.sql("CREATE TEMPORARY TABLE IF NOT EXISTS #{query_so_far.to_sql}"),
     Arel.sql("set @ct := (select count(1) from #{arel_table.table_name});"),
     Arel.sql("set @row_id := 0;"),
     query,
     Arel.sql("DROP TEMPORARY TABLE IF EXISTS #{arel_table.table_name};")]
  end

  def pg_median_datetime(arel_table, query_so_far, column_sym)
    # Create a CTE with the column we're operating on, row number (after sorting by the column
    # we're operating on), and count of the table we're operating on (duplicated across) all rows
    # of the CTE. For example, if we're looking to find the median of the `projects.star_count`
    # column, the CTE might look like this:
    #
    #  star_count | row_id | ct
    # ------------+--------+----
    #           5 |      1 |  3
    #           9 |      2 |  3
    #          15 |      3 |  3
    cte_table = Arel::Table.new("ordered_records")
    cte = Arel::Nodes::As.new(cte_table,
                              arel_table.
                                project(arel_table[column_sym].as(column_sym.to_s),
                                        Arel::Nodes::Over.new(Arel::Nodes::NamedFunction.new("row_number", []),
                                                              Arel::Nodes::Window.new.order(arel_table[column_sym])).as('row_id'),
                                        arel_table.project("COUNT(1)").as('ct')).
                                # Disallow negative values
                                where(arel_table[column_sym].gteq(zero_interval)))

    # From the CTE, select either the middle row or the middle two rows (this is accomplished
    # by 'where cte.row_id between cte.ct / 2.0 AND cte.ct / 2.0 + 1'). Find the average of the
    # selected rows, and this is the median value.
    cte_table.project(Arel::Nodes::NamedFunction.new("AVG",
                                                     [extract_epoch(cte_table[column_sym])],
                                                     "median")).
      where(Arel::Nodes::Between.new(cte_table[:row_id],
                                     Arel::Nodes::And.new([(cte_table[:ct] / Arel.sql('2.0')),
                                                           (cte_table[:ct] / Arel.sql('2.0') + 1)]))).
      with(query_so_far, cte)
  end

  private

  def extract_epoch(arel_attribute)
    Arel.sql("EXTRACT(EPOCH FROM \"#{arel_attribute.relation.name}\".\"#{arel_attribute.name}\")")
  end

  # Need to cast '0' to an INTERVAL before we can check if the interval is positive
  def zero_interval
    Arel::Nodes::NamedFunction.new("CAST", [Arel.sql("'0' AS INTERVAL")])
  end
end
