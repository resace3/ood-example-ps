require 'minitest_helper'
require 'command'

class TestCommand < Minitest::Test

  def test_command_output_parsing
    output = <<-EOF
Disk quotas for user efranz (uid 10851):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
10.11.200.32:/PZS0562/  99616M    500G    500G       0    933k   1000k   1000k       0
EOF
    quotas = Command.new.parse(output)

    assert_equal 1, quotas.count, "number of structs parsed should equal 1"

    q = quotas.first

    assert_equal "10.11.200.32:/PZS0562/", q.filesystem, "expected filesystem value not correct"
    assert_equal "99616M", q.blocks, "expected blocks value not correct"
    assert_equal "500G", q.blocks_limit, "expected blocks_limit value not correct"
    assert_equal "933k", q.files, "expected files value not correct"
    assert_equal "0", q.files_grace, "expected files_grace value not correct"
  end
end
