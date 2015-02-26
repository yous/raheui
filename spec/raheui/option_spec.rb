# encoding: utf-8

describe Raheui::Option do
  include ExitCodeMatchers
  include_context 'mocked stdout'

  subject(:option) { described_class.new }

  describe 'option' do
    describe '-h/--help' do
      it 'exits cleanly' do
        expect { option.parse(['-h']) }.to exit_with_code(0)
        expect { option.parse(['--help']) }.to exit_with_code(0)
      end

      it 'shows help text' do
        begin
          option.parse(['--help'])
        rescue SystemExit # rubocop:disable Lint/HandleExceptions
        end

        expected_help = <<-END
Usage: raheui [options] [file]
    -h, --help                       Print this message.
    -v, --version                    Print version.
        END

        expect($stdout.string).to eq(expected_help)
      end
    end

    describe '-v/--version' do
      it 'exits cleanly' do
        expect { option.parse(['-v']) }.to exit_with_code(0)
        expect { option.parse(['--version']) }.to exit_with_code(0)
        expect($stdout.string).to eq("#{Raheui::Version::STRING}\n" * 2)
      end
    end
  end
end
