# frozen_string_literal: true

class ModeConverter
  FILE_TYPES = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.each_value(&:freeze).freeze

  FILE_PERMISSIONS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.each_value(&:freeze).freeze

  def self.convert_file_mode(mode)
    octal_mode = format('%06d', mode.to_s(8))
    type = FILE_TYPES[octal_mode[0..1]]
    permission = octal_mode[3..5].gsub(/[0-7]/, FILE_PERMISSIONS)
    type + permission
  end
end
