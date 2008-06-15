# Define maximum and minimum DateTime objects for various
# adapters. We could also use nil for this, but using explicit
# values makes generating the conditions a lot easier. 
module DataMapper
  module Adapters

    class AbstractAdapter
      START_OF_TIME = DateTime.civil(1901, 12, 13, 20, 45, 52)
      END_OF_TIME   = DateTime.civil(2038,  1, 19,  3, 14,  7)
    end

    class Sqlite3Adapter
      START_OF_TIME = DateTime.civil(-4713, 11, 24, 12,  0,  0)
      END_OF_TIME   = DateTime.civil( 9999, 12, 31, 23, 59, 59)
    end

    class MysqlAdapter
      START_OF_TIME = DateTime.civil(    0,  1,  1,  0,  0,  0)
      END_OF_TIME   = DateTime.civil( 9999, 12, 31, 23, 59, 59)
    end

    class PostgresAdapter
      START_OF_TIME = DateTime.civil(  -4713, 11, 24, 12,  0,  0)
      END_OF_TIME   = DateTime.civil(5874897, 12, 31, 23, 59, 59)
    end

  end
end