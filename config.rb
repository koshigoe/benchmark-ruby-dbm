RECORD_COUNT = ARGV.first.to_i
PAIR_LENGTH  = 1_008
KEY_LENGTH   = Math.log10(RECORD_COUNT).to_i + 1
KEY_FORMAT   = "%0#{KEY_LENGTH}d"
VALUE_LENGTH = PAIR_LENGTH - KEY_LENGTH
VALUE_FORMAT = "%0#{VALUE_LENGTH}d"
DB_NAME      = "db-#{RECORD_COUNT}"
