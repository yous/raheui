# encoding: utf-8

shared_context 'mocked stdout', :mocked_stdout do
  around do |example|
    stdout = $stdout
    $stdout = StringIO.new
    example.run
    $stdout = stdout
  end
end
