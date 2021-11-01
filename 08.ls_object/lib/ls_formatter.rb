# frozen_string_literal: true

class LsFormatter
  MONTHS_TO_ALTER_FORMAT = 6

  class << self
    def format_long_row(ls_file, col_widths, time = Time.now)
      [
        "#{ls_file.mode}  ",
        format("%#{col_widths[:nlink]}d ", ls_file.nlink),
        format("%-#{col_widths[:owner]}s  ", ls_file.owner),
        format("%-#{col_widths[:group]}s  ", ls_file.group),
        format("%#{col_widths[:file_size]}d ", ls_file.size),
        "#{format_mtime(ls_file, time)} ",
        ls_file.name
      ].join
    end

    def format_mtime(ls_file, time = Time.now)
      format = if ls_file.mtime_before_or_after_month?(MONTHS_TO_ALTER_FORMAT, time)
                 '%b %e %_5Y'
               else
                 '%b %e %H:%M'
               end
      ls_file.mtime.strftime(format)
    end
  end
end
