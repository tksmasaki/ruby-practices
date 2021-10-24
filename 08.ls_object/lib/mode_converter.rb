# frozen_string_literal: true

class ModeConverter
  class << self
    def convert_file_mode(mode)
      octal_mode = format('%06d', mode.to_s(8))
      convert_octal_type(octal_mode[0..1]) + octal_mode[3..5].chars.map { |v| convert_octal_permission(v) }.join
    end

    private

    def convert_octal_type(type_num)
      {
        '01' => 'p',
        '02' => 'c',
        '04' => 'd',
        '06' => 'b',
        '10' => '-',
        '12' => 'l',
        '14' => 's'
      }[type_num]
    end

    def convert_octal_permission(permission_num)
      {
        '0' => '---',
        '1' => '--x',
        '2' => '-w-',
        '3' => '-wx',
        '4' => 'r--',
        '5' => 'r-x',
        '6' => 'rw-',
        '7' => 'rwx'
      }[permission_num]
    end
  end
end
