describe 'functions' do

  subject { Wyrm::Evaluator.new(code).eval.stdout }

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

  context 'simple params' do
    let(:code) do
      %(
        fn fn_name(param_1, param_2) print(param_1, param_2)
        fn_name(5, 'test')
      )
    end

    it { is_expected.to include('5 test') }
  end

  context 'local bindings' do
    let(:code) do
      %(
        fn fn1() a = 10
        fn1()
        print(a)
      )
    end

    it { expect{subject}.to raise_error }
  end


  context 'overwrite bindings' do
    let(:code) do
      %(
        a = 1
        fn fun() a = 10
        fun()
        print(a)
      )
    end

    it {is_expected.to include('10') }
  end

  context 'dont share bindings' do
    let(:code) do
      %(
        fn fun1() a = 10
        fn fun2() print(a)
        fun1()
        fun2()
      )
    end

    it { expect{subject}.to raise_error }
  end

  context 'share binding form upper scope' do
    let(:code) do
      %(
        a = 0
        fn fun1() a = 10
        fn fun2() print(a)
        fun1()
        fun2()
      )
    end

    it {is_expected.to include('10') }
  end

  context 'anonymous function' do
    let(:code) do
      %(
        fun = fn() 5
        print(fun())
      )
    end

    it {is_expected.to include('5') }
  end

  context 'return value' do
    let(:code) do
      %(
        fn fun() 10
        print(fun())
      )
    end

    it {is_expected.to include('10') }
  end

  context 'share bindings form parent' do
    let(:code) do
      %(
        fn add(x) fn(y) y + x
        add_five = add(5)
        print(add_five(10))
      )
    end

    it {is_expected.to include('15') }
  end

  context do
    let(:code) do
      %(
        fn gen(name)
          iter = 0
          fn()
            iter = iter + 1
            print(name + ':', iter)
          end
        end
        first = gen('first')
        first()
        second = gen('second')
        second()
        first()
        second()
      )
    end

    it {is_expected.to include('first: 1', 'second: 1', 'first: 2', 'second: 2') }
  end
end
