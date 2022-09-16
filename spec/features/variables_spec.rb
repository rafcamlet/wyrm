describe 'variables' do

  subject { Scratch::Evaluator.new(code).eval.stdout }

  context do
    let(:code) do
      %(
         var = 5
         print(var)
      )
    end

    it { is_expected.to include('5') }
  end

end
