# frozen_string_literal: true

class LsFormatter
  class << self
    def format_long_row(ls_file, nlink_width, owner_width, group_width, size_width)
      [
        "#{ls_file.mode}  ",
        format("%#{nlink_width}d ", ls_file.nlink),
        format("%-#{owner_width}s  ", ls_file.owner),
        format("%-#{group_width}s  ", ls_file.group),
        format("%#{size_width}d ", ls_file.size),
        "#{format_mtime(ls_file)} ",
        ls_file.name
      ].join
    end

    def format_mtime(ls_file)
      num_months = 6
      if ls_file.mtime_before_or_after_month?(num_months)
        ls_file.mtime.strftime('%b %e %_5Y')
      else
        ls_file.mtime.strftime('%b %e %H:%M')
      end
    end
  end
end
