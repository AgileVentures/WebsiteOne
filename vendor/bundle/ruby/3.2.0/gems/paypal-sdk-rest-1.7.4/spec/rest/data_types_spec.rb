module PayPal::SDK::REST::DataTypes
  describe Base do
    let(:error_object) {
      {
        "name" => "INVALID_EXPERIENCE_PROFILE_ID",
        "message" => "The requested experience profile ID was not found",
        "information_link" => "https://developer.paypal.com/docs/api/#INVALID_EXPERIENCE_PROFILE_ID",
        "debug_id" => "1562931a79fd2"
      }
    }

    context '#raise_error!' do
      context 'when there is error' do
        subject { described_class.new(error: error_object) }

        it 'raises error on request with all API information' do
          expect { subject.raise_error! }
            .to raise_error { |err|
              expect(err).to be_a(PayPal::SDK::Core::Exceptions::UnsuccessfulApiCall)
              expect(err.message).to eq("The requested experience profile ID was not found")
              expect(err.api_error).to eq(error_object)
            }
        end
      end

      context 'when there is no error' do
        subject { described_class.new(error: nil) }

        it { expect { subject.raise_error! }.not_to raise_error }
      end
    end

    context '.raise_on_api_error' do
      let(:klass) {
        Class.new(described_class) do
          def some_call
          end

          raise_on_api_error :some_call
        end
      }

      subject { klass.new }

      context 'when call is successful' do
        before {
          expect(subject).to receive(:some_call).and_return(true)
        }
        it { expect { subject.some_call! }.not_to raise_error }
      end

      context 'when call is unsuccessful' do
        before {
          expect(subject).to receive(:some_call).and_return(false)
          expect(subject).to receive(:error).twice.and_return(error_object)
        }

        it { expect { subject.some_call! }.to raise_error(PayPal::SDK::Core::Exceptions::UnsuccessfulApiCall) }
      end
    end
  end
end
