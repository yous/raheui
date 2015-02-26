# encoding: utf-8

require 'spec_helper'

describe Raheui::CLI do
  include FileHelper
  include_context 'isolated environment'
  include_context 'mocked stdout'

  subject(:cli) { described_class.new }

  it 'runs aheui file passed as an argument' do
    create_file('helloworld.aheui', %w(밤밣따빠밣밟따뿌
                                       빠맣파빨받밤뚜뭏
                                       돋밬탕빠맣붏두붇
                                       볻뫃박발뚷투뭏붖
                                       뫃도뫃희멓뭏뭏붘
                                       뫃봌토범더벌뿌뚜
                                       뽑뽀멓멓더벓뻐뚠
                                       뽀덩벐멓뻐덕더벅))
    expect(cli.run(['helloworld.aheui'])).to be(0)
    expect($stdout.string).to eq("Hello, world!\n")
  end

  it 'runs string passed as an stdin argument' do
    allow($stdin).to receive(:read).once
      .and_return(%w(밤밣따빠밣밟따뿌
                     빠맣파빨받밤뚜뭏
                     돋밬탕빠맣붏두붇
                     볻뫃박발뚷투뭏붖
                     뫃도뫃희멓뭏뭏붘
                     뫃봌토범더벌뿌뚜
                     뽑뽀멓멓더벓뻐뚠
                     뽀덩벐멓뻐덕더벅).join("\n"))
    expect(cli.run([])).to be(0)
    expect($stdout.string).to eq("Hello, world!\n")
  end
end
