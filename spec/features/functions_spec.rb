describe 'functions' do

  subject { Scratch::Evaluator.new(code).eval.stdout }

  context 'oneliner' do
    let(:code) do
      %(
         fn fn_name() print("test")
         fn_name()
      )
    end

    it { is_expected.to include('test') }
  end

  context 'multiline' do
    let(:code) do
      %(
         fn fn_name()
           print("test")
           print("test2")
         end

         fn_name()
      )
    end

    it { is_expected.to include('test', 'test2') }
  end
end
