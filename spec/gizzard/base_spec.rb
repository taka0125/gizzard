RSpec.describe Gizzard::Base do
  describe '.delete_all_by_id' do
    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    context 'without scope' do
      subject { Item.delete_all_by_id }

      it do
        subject

        expect(Item.count).to eq 0
      end
    end

    context 'with scope' do
      subject { Item.where(id: 2).delete_all_by_id }

      it do
        subject

        expect(Item.pluck(:id).sort).to eq [1, 3]
      end
    end
  end

  describe '.less_than' do
    subject { Item.less_than(:id, value) }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    context 'value is present' do
      let(:value) { 2 }

      it { expect(subject.pluck(:id).sort).to eq [1] }
    end

    context 'value is not present' do
      let(:value) {}

      it { expect(subject.pluck(:id).sort).to eq [1, 2, 3] }
    end
  end

  describe '.less_than_equal' do
    subject { Item.less_than_equal(:id, value) }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    context 'value is present' do
      let(:value) { 2 }

      it { expect(subject.pluck(:id).sort).to eq [1, 2] }
    end

    context 'value is not present' do
      let(:value) {}

      it { expect(subject.pluck(:id).sort).to eq [1, 2, 3] }
    end
  end

  describe '.less_than_id' do
    subject { Item.less_than_id(2) }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    it { expect(subject.pluck(:id).sort).to eq [1] }
  end

  describe '.greater_than' do
    subject { Item.greater_than(:id, value) }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    context 'value is present' do
      let(:value) { 2 }

      it { expect(subject.pluck(:id).sort).to eq [3] }
    end

    context 'value is not present' do
      let(:value) {}

      it { expect(subject.pluck(:id).sort).to eq [1, 2, 3] }
    end
  end

  describe '.greater_than_equal' do
    subject { Item.greater_than_equal(:id, value) }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    context 'value is present' do
      let(:value) { 2 }

      it { expect(subject.pluck(:id).sort).to eq [2, 3] }
    end

    context 'value is not present' do
      let(:value) {}

      it { expect(subject.pluck(:id).sort).to eq [1, 2, 3] }
    end
  end

  describe '.greater_than_id' do
    subject { Item.greater_than_id(2) }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'item3')
      end
    end

    it { expect(subject.pluck(:id).sort).to eq [3] }
  end
end
