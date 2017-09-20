require 'open3'

class Command
  def to_s
    "quota -spw"
  end

  Quota = Struct.new(:filesystem, :blocks, :blocks_quota, :blocks_limit, :blocks_grace, :files, :files_quota, :files_limit, :files_grace)

  # Parse a string output from the `ps aux` command and return an array of
  # AppProcess objects, one per process
  def parse(output)
    lines = output.strip.split("\n")
    lines.drop(2).map do |line|
      Quota.new(*(line.split))
    end
  end

  # Execute the command, and parse the output, returning and array of
  # AppProcesses and nil for the error string.
  #
  # returns [Array<Array<AppProcess>, String] i.e.[processes, error]
  def exec
    processes, error = [], nil

    stdout_str, stderr_str, status = Open3.capture3(to_s)
    if status.success?
      processes = parse(stdout_str)
    else
      error = "Command '#{to_s}' exited with error: #{stderr_str}"
    end

    [processes, error]
  end
end
