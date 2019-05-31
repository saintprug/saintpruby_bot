RSpec.describe Services::Beer do
  subject(:beer_service) { described_class.new(repo: beer_repo) }
  let(:beer_repo) { instance_double(Repositories::BeerRepo) }
  let(:user_id) { 'whatever' }

  describe '#drink' do
    it 'creates new drunk beer' do
      expect(beer_repo).to receive(:create)

      beer_service.drink(user_id)
    end
  end

  describe '#last' do
    before do
      allow(beer_repo).to receive(:find_by_user_id).and_return(beer)
    end

    context 'user already drunk' do
      let(:first_drunk) { stringify_time(Time.now - 2) }
      let(:second_drunk) { stringify_time(Time.now - 1) }
      let(:beer) { Entities::DrunkBeer.new(user_id: user_id, drunk_at: [first_drunk, second_drunk]) }

      it 'returns second drunk beer' do
        expect(beer_service.last('user_id')).to eq(Time.parse(second_drunk))
      end
    end

    context 'user doesnt drunk' do
      let(:beer) { Entities::DrunkBeer.new(user_id: user_id, drunk_at: []) }

      it 'returns second drunk beer' do
        expect(beer_service.last('user_id')).to eq(nil)
      end
    end
  end

  describe '#user_total' do
    before do
      allow(beer_repo).to receive(:find_by_user_id).and_return(beer)
    end

    context 'user already drunk' do
      let(:first_drunk) { stringify_time(Time.now - 2) }
      let(:second_drunk) { stringify_time(Time.now - 1) }
      let(:beer) { Entities::DrunkBeer.new(user_id: user_id, drunk_at: [first_drunk, second_drunk]) }

      it 'returns second drunk beer' do
        expect(beer_service.user_total('user_id')).to eq 2
      end
    end

    context 'user doesnt drunk' do
      let(:beer) { Entities::DrunkBeer.new(user_id: user_id, drunk_at: []) }

      it 'returns second drunk beer' do
        expect(beer_service.user_total('user_id')).to eq 0
      end
    end
  end

  describe '#total' do
    let(:beers) do
      [
        Entities::DrunkBeer.new(user_id: 'foo', drunk_at: [stringify_time(Time.now)]),
        Entities::DrunkBeer.new(user_id: 'bar', drunk_at: [stringify_time(Time.now - 1)]),
        Entities::DrunkBeer.new(user_id: 'baz', drunk_at: [stringify_time(Time.now - 2)]),
      ]
    end

    before do
      allow(beer_repo).to receive(:all).and_return(beers)
    end

    it 'returns total count' do
      expect(beer_service.total).to eq 3
    end
  end

  describe '#drinks_fast' do
    let(:last_beer) { Entities::DrunkBeer.new(user_id: 'baz', drunk_at: [stringify_time(Time.now - 50)]) }

    before do
      allow(beer_service).to receive(:last).and_return(last_beer.drunk_at.first)
    end

    it 'returns boolean' do
      expect(beer_service.drinks_fast?(user_id)).to eq true
    end
  end

  describe '#user_total_by_last_day' do
    let(:beer) do
      Entities::DrunkBeer.new(
        user_id: 'foo',
        drunk_at: [
          stringify_time(Time.now - 60 * 60 * 12),
          stringify_time(Time.now - 60 * 60 * 7),
          stringify_time(Time.now)
        ]
      )
    end

    before do
      allow(beer_repo).to receive(:find_by_user_id).and_return(beer)
    end

    it 'returns integer' do
      expect(beer_service.user_total_by_last_day(user_id)).to eq 2
    end
  end

  def stringify_time(time)
    time.to_s
  end
end
