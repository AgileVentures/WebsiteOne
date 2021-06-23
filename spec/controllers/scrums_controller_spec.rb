# frozen_string_literal: true

describe ScrumsController do
  let!(:scrum) { FactoryBot.create(:event_instance, category: 'Scrum', created_at: DateTime.now) }
  let!(:scrum2) { FactoryBot.create(:event_instance, category: 'Scrum', created_at: DateTime.now.at_beginning_of_day) }
  let!(:hangout) { FactoryBot.create(:event_instance, category: 'PairProgramming') }

  describe '#index' do
    context '@scrums instance variable' do
      before { get :index }

      context 'the array of videos' do
        subject { assigns(:scrums) }

        it 'the last video has an older date than the first video' do
          expect(subject.last.created_at).to be < subject.first.created_at
        end

        it 'includes instances with category Scrum' do
          expect(subject).to include scrum, scrum2
        end

        it 'does not includes instances with category PairProgramming' do
          expect(subject).to_not include hangout
        end
      end
    end
  end
end
