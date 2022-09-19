# https://rspec.rubystyle.guide/#use-contexts
# You should read this

describe 'conditions' do
  subject { Scratch::Evaluator.new(code).eval.stdout }

  describe 'and' do
    context 'when condition is positive' do
      let(:code) { 'true and print("wow")' }

      it { is_expected.to include('wow') }
    end

    context 'when condition is negative' do
      let(:code) { 'false and print("wow")' }

      it { is_expected.to be_empty }
    end
  end

  describe 'or' do
    context 'when condition is positive' do
      let(:code) { 'print(1 or 2)' }

      it { is_expected.to include('1') }
    end

    context 'when condition is negative' do
      let(:code) { 'false or print("wow")' }

      it { is_expected.to include('wow') }
    end
  end

  describe 'precedence' do
    let(:code) { 'print(false or 1 and 2)' }

    it { is_expected.to include('2') }
  end
end
