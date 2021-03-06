# encoding: utf-8

shared_examples 'a runner' do
  subject(:runner) { Raheui::Runner.new(code) }
  let(:code) { Raheui::Code.new(source) }
  let(:output) { $stdout.string }

  before(:example) do
    $stdin = StringIO.new
    $stdout = StringIO.new
  end

  after(:example) do
    $stdin = STDIN
    $stdout = STDOUT
  end

  it 'accepts input, prints expected output and returns exit code' do
    if defined?(inputs)
      inputs.each do |line|
        $stdin.puts line
      end
      $stdin.rewind
    end
    expect(runner.run).to be(exit_code)
    expect(output).to eq(result)
  end
end

describe Raheui::Runner do
  it 'has frozen constants' do
    expect(described_class.const_get(:REQUIRED_STORE_SIZE)).to be_frozen
    expect(described_class.const_get(:MEDIAL_DELTAS)).to be_frozen
    expect(described_class.const_get(:FINAL_STROKES)).to be_frozen
  end

  describe 'standard specifications' do
    context 'with bieup.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
박반받발밤밥밧밪밫밬밭붚
뭉멍멍멍멍멍멍멍멍멍멍멍
밖밗밙밚밝밞밟밠밡밢밣밦붔
뭉멍멍멍멍멍멍멍멍멍멍멍멍
방붛
뭉멍
희

ㅂ에 ㅇ받침이 있으면 입력받은 숫자를, ㅎ받침이 있으면 입력받은 문자의 유니코드 코드값을 저장공간에 집어넣습니다. 단, ㅂ의 경우 나머지 받침이 있으면 그 받침을 구성하는 선의 수에 따른 값을 집어넣습니다. 받침이 없으면 0을 집어넣습니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:inputs) { %w(3 밯) }
      let(:result) { '4434324453224689979975544481753' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with border.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
볻         망볿
ㅇ         ㅇ희
멍         붒
ㅇ         ㅇ몽


                  표준: 코드 공간의 한 쪽 끝에 다다르면 커서는 반대편 끝으로 이동합니다. 이는 Funge-98의 wrapping algorithm과 동일합니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '369' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with chieut.aheui' do
      let(:source) { <<-END }
아ㅇㅇ부
희멍번처붇
ㅇㅇㅇ분멍
희멍번차붇
ㅇㅇㅇ희멍
ㅊ은 조건 명령으로 저장공간에서 값 하나를 뽑아내서 그 값이 0이 아니면 홀소리의 방향대로, 0이면 그 반대 방향대로 갑니다.
      END

      let(:result) { '33' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with default-storage.aheui' do
      let(:source) { <<-END }
밞산바삳바사망희

처음에 선택되어 있는 스택은 (받침 없음) 스택입니다. (“사” 와 같은 명령으로 선택할 수 있습니다.)
      END

      let(:result) { '9' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with digeut.aheui' do
      let(:source) { <<-END }
반받다망희

ㄷ은 덧셈 명령으로 저장공간에서 두 값을 뽑아낸 다음 둘을 더한 값을 저장공간에 집어넣습니다.
      END

      let(:result) { '5' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with exhausted-storage.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
아ㅇㅇ우
희멍벋망반망희
중복 명령을 포함한 모든 뽑아내기를 쓰는 명령에서 저장 공간에 값이 모자랄 경우, 커서는 그 명령을 실행하지 않고 커서가 있는 글자의 홀소리의 반대방향으로 움직입니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '3' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with exitcode.aheui' do
      let(:source) { <<-END }
반월회

ㅎ은 끝냄 명령으로 커서의 실행을 끝냅니다. 이 때 스택에서 맨 위 값을 뽑아서 운영체제에 돌려 줍니다.
      END

      let(:result) { '' }
      let(:exit_code) { 2 }

      it_behaves_like 'a runner'
    end

    context 'with ieunghiheuit.aheui' do
      let(:source) { <<-END }
아악안앋압알앗았앜앇헐

ㅇ은 없음 명령으로 아무 일도 하지 않습니다. * ㅎ은 끝냄 명령으로 커서의 실행을 끝냅니다.
사용되지 않는 받침은 모두 무시됩니다.
      END

      let(:result) { '' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with jieut.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
반반자망받반자망반받자망희

ㅈ은 비교 명령으로 저장공간에서 값 두 개를 뽑아 내서 비교합니다. 나중에 뽑아낸 값이 더 크거나 같으면 1을, 아니면 0을 지금 저장공간에 집어넣습니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '110' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with loop.aheui' do
      let(:source) { <<-END }
밦밦따빠뚜
뿌뚜뻐뚜뻐
따ㅇㅇㅇ우
ㅇㅇ아ㅇ분
ㅇㅇ초뻐터
ㅇㅇ망희
      END

      let(:result) { '0' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with mieum.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
바반받밤발밦밠밣밞망만맘말망맋맠맟망희

ㅁ에 ㅇ받침이 있으면 저장공간에서 뽑아낸 값을 숫자로, ㅎ받침이 있으면 그 값에 해당하는 유니코드 문자로 출력합니다. 나머지 받침은 뽑아낸 값을 그냥 버립니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '950' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with nieun.aheui' do
      let(:source) { <<-END }
밟받나망희

ㄴ은 나눗셈 명령으로 저장공간에서 두 값을 뽑아낸 다음 나중 값에서 먼저 값을 나눈 값을 저장공간에 집어넣습니다.
      END

      let(:result) { '3' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with pieup.aheui' do
      let(:source) { <<-END }
바밟밟땅밝밝땅팡망망우
숭ㅇㅇㅇㅇㅇㅇㅇㅇㅇ어
밟밟밝밝땅땅바팡망망희

ㅍ은 바꿔치기 명령입니다. 지금 저장공간이 스택이라면 맨 위 값과 그 바로 아래 값을, 큐라면 맨 앞의 값과 그 바로 뒤 값을 바꿉니다.
      END

      let(:result) { '81494981' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with print.aheui' do
      let(:source) { <<-END }
밞밞반다따반타뭉
ㅇㅇㅇㅇㅇㅇㅇ밞밞반다따반타맣희

ㅁ에 ㅇ받침이 있으면 저장공간에서 뽑아낸 값을 숫자로, ㅎ받침이 있으면 그 값에 해당하는 유니코드 문자로 출력합니다.
      END

      let(:result) { '97a' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with queue.aheui' do
      let(:source) { <<-END }
상반받뱔우망이
뭉뻐벋번성
망망희
      END

      let(:result) { '235223' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with rieul.aheui' do
      let(:source) { <<-END }
밟발라망희

ㄹ은 나머지 명령으로 저장공간에서 두 값을 뽑아낸 다음 나중 값에서 먼저 값을 나눈 나머지를 저장공간에 집어넣습니다.
      END

      let(:result) { '4' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with shebang.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
#!/usr/bin/env aheui
반망희

표준: 커서는 코드 공간의 맨 첫 줄 맨 첫번째 칸에서 시작합니다. 맨 처음에 홀소리가 없을 경우 커서는 기본값으로 아랫쪽으로 이동하는데, 이는 #!과 호환시키기 위한 것으로, 기본 방향이 오른쪽인 funge와는 다른 점입니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '2' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with ssangbieup.aheui' do
      let(:source) { <<-END }
밟밟땅빵망망희

ㅃ은 중복 명령입니다. 지금 저장공간이 스택이라면 맨 위의 값을 그 값 위에 하나 더 집어넣고, 큐라면 맨 앞의 값을 앞에 하나 더 덧붙입니다.
      END

      let(:result) { '8181' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with ssangdigeut.aheui' do
      let(:source) { <<-END }
발밞따망희

ㄸ은 곱셈 명령으로 저장공간에서 두 값을 뽑아낸 다음 둘을 곱한 값을 저장공간에 집어넣습니다.
      END

      let(:result) { '45' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with ssangsiot.aheui' do
      let(:source) { <<-END }
아바싹반싼받싿우
우멍석멍선멍섣어
아바쌀반쌈받쌉우
우멍설멍섬멍섭어
아바쌋반쌍받쌎우
우멍섯멍성멍섲어
아바쌏반쌐받쌑우
우멍섳멍섴멍섵어
아바쌒반싺받싻우
우멍섶멍섞멍섟어
아바싽반싾받쌁우
우멍섡멍섢멍섥어
아바쌂반쌃받쌄우
우멍섦멍섧멍섨어
아바쌅반쌆받쌇우
우멍섩멍섪멍섫어
아바쌊반쌌받싸우
희멍섮멍섰멍서어

ㅆ은 이동 명령으로 저장공간에서 값 하나를 뽑아내서 받침이 나타내는 저장공간에 그 값을 집어 넣습니다.
      END

      let(:result) { '320320320320320320320320320' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with storage.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
바반받뭉
우석멍멍
바반받뭉
우선멍멍
바반받뭉
우섣멍멍
바반받뭉
우설멍멍
바반받뭉
우섬멍멍
바반받뭉
우섭멍멍
바반받뭉
우섯멍멍
바반받뭉
우성멍멍
바반받뭉
우섲멍멍
바반받뭉
우섳멍멍
바반받뭉
우섴멍멍
바반받뭉
우섵멍멍
바반받뭉
우섶멍멍
바반받뭉
끝희멍멍

아희에서 쓰이는 저장 공간은 여러 개가 있습니다. 대부분이 스택이고, 큐가 하나 있습니다.
ㅁ은 뽑기 명령입니다. 지금 저장공간이 스택이라면 맨 위의 값, 큐라면 맨 앞의 값을 뽑아냅니다.(pop) 통로라면 거기서 값을 하나 뽑아옵니다. ㅁ 명령에는 받침이 올 수 있는데, 이에 대한 설명은 아래에 있습니다.
ㅁ에 ㅇ받침이 있으면 저장공간에서 뽑아낸 값을 숫자로, ㅎ받침이 있으면 그 값에 해당하는 유니코드 문자로 출력합니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '320320320320320320320320023320320320320320' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with syllable.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
ㅏ희ㅣㅊㅓ
뱓ㅗㅈㅊ몽
ㅂㅁㅎㅣ헥

코드는 한글로만 이루어지는데, 여기서 한글은 유니코드 U+AC00에서 U+D7A3까지의 범위에 있는 글자(hangul syllable 영역)를 말합니다. 그 밖의 글자나 코드에서 지정하지 않은 나머지 공간은 모두 빈 칸으로 처리되어 커서가 이동하는 방향에 아무 영향을 주지 않습니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '3' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with tieut.aheui' do
      let(:source) { <<-END }
받반타망희

ㅌ은 뺄셈 명령으로 저장공간에서 두 값을 뽑아낸 다음 나중 값에서 먼저 값을 뺀 값을 저장공간에 집어넣습니다.
      END

      let(:result) { '1' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with vowel-2step.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
뷷우희어밍우여
아아아아아아아반받망희
먕오뱞오뱗오뵬

ㅑ, ㅕ, ㅛ, ㅠ - 커서를 각각 오른쪽, 왼쪽, 위, 아래로 두 칸 옮깁니다.
중복 명령을 포함한 모든 뽑아내기를 쓰는 명령에서 저장 공간에 값이 모자랄 경우, 커서는 그 명령을 실행하지 않고 커서가 있는 글자의 홀소리의 반대방향으로 움직입니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '3596' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with vowel-advanced.aheui' do
      let(:source) { <<-END }
반븓븝불
우멍벎망이밟망희
빈
빋밟망희
붑으
발몽
ㅇ밞망분
ㅇ불법벋
의멍밞망희

ㅡ - 커서가 가로로 왔으면 그 방향대로, 세로로 왔으면 전에 있던 자리로 옮깁니다.
ㅣ - 커서가 세로로 왔으면 그 방향대로, 가로로 왔으면 전에 있던 자리로 옮깁니다.
ㅢ - 커서를 전에 있던 자리로 옮깁니다.
      END

      let(:result) { '543295432954329' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with vowel-basic.aheui' do
      let(:source) { <<-END }
붇희희멍
망밦망볿

ㅏ, ㅓ, ㅗ, ㅜ - 커서를 각각 오른쪽, 왼쪽, 위, 아래로 한 칸 옮깁니다.
      END

      let(:result) { '369' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with vowel-useless.aheui' do
      let(:source) { <<-END }
우아앙배벤뱯볩뷜뫙뫵뮝뭥뮁우
배맹희맹멩먱몡뮝봘봽붣붠붸어
벤멩
뱯먱
볩몡
뷜뮝
뫙봘
뫵봽
묑뵏
뭥붠
뮁붸
아오

기능 없음: ㅐ ㅔ ㅒ ㅖ ㅘ ㅙ ㅚ ㅝ ㅞ ㅟ (커서가 이동하는 방향은 변하지 않습니다.)
      END

      let(:result) { '54320543205432054320' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with vowel-useless2.aheui' do
      let(:source) { <<-END }
와아앙배벤뱯볩뷜뫙뫵뮝뭥뮁우
배맹희맹멩먱몡뮝봘봽붣붠붸어
벤멩
뱯먱
볩몡
뷜뮝
뫙봘
뫵봽
묑뵏
뭥붠
뮁붸
아오

기능 없음: ㅐ ㅔ ㅒ ㅖ ㅘ ㅙ ㅚ ㅝ ㅞ ㅟ (커서가 이동하는 방향은 변하지 않습니다.)
      END

      let(:result) { '54320543205432054320' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end
  end

  describe 'undefined specifications' do
    context 'with 2steps.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
야ㅇ븐븐븓븓야이멍희

ㅡ - 커서가 가로로 왔으면 그 방향대로, 세로로 왔으면 전에 있던 자리로 옮깁니다.
기능 없음: ㅐ ㅔ ㅒ ㅖ ㅘ ㅙ ㅚ ㅝ ㅞ ㅟ (커서가 이동하는 방향은 변하지 않습니다.)

해설: 2칸 이동 후 다음 이동에 관해 방향은 정의되어 있지만 이동 간격을 유지하는지는 정의되어 있지 않습니다. 유지하는 경우 32가 나옵니다. 유지하지 않는 경우 무슨 동작을 할 지 짐작도 안되니 유지하는 편을 권장합니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '32' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    xcontext 'with bieup.aheui' do
      let(:source) { <<-END }
밯이

ㅂ도 마찬가지로 ㅇ받침이 있으면 입력받은 숫자를, ㅎ받침이 있으면 입력받은 문자의 유니코드 코드값을 저장공간에 집어넣습니다.

해설: EOF를 만나거나 ㅇ 받침에 숫자로 해석할 수 없는 값이 들어올 경우의 동작이 정의되지 않았습니다. 권장 구현은 없습니다.
      END
    end

    xcontext 'with boundary.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
아아아아아우
바야희망희야

코드 공간의 한 쪽 끝에 다다르면 커서는 반대편 끝으로 이동합니다. 이는 Funge-98의 wrapping algorithm과 동일합니다.

해설: Funge-98에는 2칸씩 이동하는 경우가 없으므로 줄끝에 '야'가 온 경우 '바'로 이동할지 '야'로 이동할지 불명확합니다. 2칸 이동을 하나의 이동으로 볼 경우 한 쪽 끝에 다다랐으므로 '바'로 이동합니다. 2칸 이동을 2개의 1칸 이동으로 볼 경우 한 쪽 끝에 다다라 '바'로 이동 후 한번 더 이동해 '야'로 이동합니다. 어느 쪽도 합리적인 해석이고 불이익을 판단하기 어려우므로 권장 구현은 없습니다.
      END
      # rubocop:enable Metrics/LineLength
    end

    context 'with chieut.aheui' do
      let(:source) { <<-END }
반쵕반망희

ㅊ은 조건 명령으로 저장공간에서 값 하나를 뽑아내서 그 값이 0이 아니면 홀소리의 방향대로, 0이면 그 반대 방향대로 갑니다.

해설: 방향 없는 홀소리가 나왔을 때의 동작이 정의되지 않았습니다. 경로 유지 외에는 추측 가능한 동작이 없으므로 경로 유지를 권장합니다.
      END

      let(:result) { '2' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end

    context 'with emptyswap.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
뱐희파반망희

중복 명령을 포함한 모든 뽑아내기를 쓰는 명령에서 저장 공간에 값이 모자랄 경우, 커서는 그 명령을 실행하지 않고 커서가 있는 글자의 홀소리의 반대방향으로 움직입니다.
ㅍ은 바꿔치기 명령입니다. 지금 저장공간이 스택이라면 맨 위 값과 그 바로 아래 값을, 큐라면 맨 앞의 값과 그 바로 뒤 값을 바꿉니다. (통로라면?)

해설: 중복을 별도로 명시하고 있다는 점에서 큐에서 뽑기와 동작이 다른 경우 뽑기 동작으로 취급하지 않음을 알 수 있습니다. 큐의 바꿔치기도 역시 뽑기로는 구현이 불가능하므로 뽑아내기가 들어가는 명령이 아닌 것으로 추측되지만, 그 경우 동작은 정의되지 않으므로 반대로 가는 편을 권장합니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '' }
      let(:exit_code) { 2 }

      it_behaves_like 'a runner'
    end

    context 'with hieut-pop.aheui' do
      # rubocop:disable Metrics/LineLength
      let(:source) { <<-END }
하멍번버

- 조건1: ㅎ은 끝냄 명령으로 커서의 실행을 끝냅니다. 이 때 스택에서 맨 위 값을 뽑아서 운영체제에 돌려 줍니다.
- 조건2: 중복 명령을 포함한 모든 뽑아내기를 쓰는 명령에서 저장 공간에 값이 모자랄 경우, 커서는 그 명령을 실행하지 않고 커서가 있는 글자의 홀소리의 반대방향으로 움직입니다.

- 해설: 스택이 차 있을 경우 조건2에 의해 ㅎ은 프로그램을 종료하지 못하고 2를 출력 후 종료해야 합니다. 하지만 대부분의 구현체는 이 경우 프로그램을 종료합니다.
      END
      # rubocop:enable Metrics/LineLength

      let(:result) { '' }
      let(:exit_code) { 0 }

      it_behaves_like 'a runner'
    end
  end
end
