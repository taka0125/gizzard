RSpec.describe Gizzard::Mysql do
  describe '.filtered_by' do
    subject { Item.filtered_by(column, value) }

    context 'without space' do
      let(:column) { :field1 }
      let(:value) { 'item2' }

      before do
        ApplicationRecord.transaction do
          Item.create!(id: 1, field1: 'item1')
          Item.create!(id: 2, field1: 'item2')
          Item.create!(id: 3, field1: 'item3')
        end
      end

      it { expect(subject.pluck(:id).sort).to eq [2] }
    end

    context 'with space' do
      let(:column) { :field1 }
      let(:value) { 'item2 ' }

      before do
        ApplicationRecord.transaction do
          Item.create!(id: 1, field1: 'item1')
          Item.create!(id: 2, field1: 'item2')
          Item.create!(id: 3, field1: 'item3')
        end
      end

      it { expect(subject.pluck(:id).sort).to eq [2] }
    end
  end

  describe '.forward_matching_by' do
    subject { Item.forward_matching_by(column, value) }

    let(:column) { :field1 }
    let(:value) { 'item' }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'hogeitem')
        Item.create!(id: 4, field1: 'none')
      end
    end

    it { expect(subject.pluck(:id).sort).to eq [1, 2] }
  end

  describe '.backward_matching_by' do
    subject { Item.backward_matching_by(column, value) }

    let(:column) { :field1 }
    let(:value) { 'item' }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'hogeitem')
        Item.create!(id: 4, field1: 'none')
      end
    end

    it { expect(subject.pluck(:id).sort).to eq [3] }
  end

  describe '.partial_matching_by' do
    subject { Item.partial_matching_by(column, value) }

    let(:column) { :field1 }
    let(:value) { 'item' }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'hogeitem')
        Item.create!(id: 4, field1: 'none')
      end
    end

    it { expect(subject.pluck(:id).sort).to eq [1, 2, 3] }
  end

  describe '.order_by_field' do
    subject { Item.where(id: values).order_by_field(column, values) }

    let(:column) { :id }
    let(:values) { [1, 3, 2] }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'hogeitem')
        Item.create!(id: 4, field1: 'none')
      end
    end

    it { expect(subject.to_a.map(&:id)).to eq values }
  end

  describe '.order_by_id_field' do
    subject { Item.where(id: ids).order_by_id_field(ids) }

    let(:ids) { [1, 3, 2] }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
        Item.create!(id: 2, field1: 'item2')
        Item.create!(id: 3, field1: 'hogeitem')
        Item.create!(id: 4, field1: 'none')
      end
    end

    it { expect(subject.to_a.map(&:id)).to eq ids }
  end

  describe '.use_index' do
    subject { Item.use_index('key_items_1').all }

    it { expect(subject.to_sql).to include 'USE INDEX(key_items_1)' }
  end

  describe '.force_index' do
    subject { Item.force_index('key_items_1').all }

    it { expect(subject.to_sql).to include 'FORCE INDEX(key_items_1)' }
  end

  describe '.joins_with_use_index' do
    subject { Item.joins_with_use_index(:item_details, 'key_item_details_1').all }

    it { expect(subject.to_sql).to include 'INNER JOIN `item_details` USE INDEX(key_item_details_1)' }
  end

  describe '.joins_with_force_index' do
    subject { Item.joins_with_force_index(:item_details, 'key_item_details_1').all }

    it { expect(subject.to_sql).to include 'INNER JOIN `item_details` FORCE INDEX(key_item_details_1)' }
  end

  describe '.left_outer_joins_with_use_index' do
    subject { Item.left_outer_joins_with_use_index(:item_details, 'key_item_details_1').all }

    it { expect(subject.to_sql).to include 'LEFT OUTER JOIN `item_details` USE INDEX(key_item_details_1)' }
  end

  describe '.left_outer_joins_with_force_index' do
    subject { Item.left_outer_joins_with_force_index(:item_details, 'key_item_details_1').all }

    it { expect(subject.to_sql).to include 'LEFT OUTER JOIN `item_details` FORCE INDEX(key_item_details_1)' }
  end

  describe '.lock_in_share' do
    subject { Item.where(id: 1).lock_in_share }

    it { expect(subject.to_sql).to include 'SELECT `items`.* FROM `items` WHERE `items`.`id` = 1 LOCK IN SHARE MODE' }
  end

  describe '#to_id' do
    subject { Item.new(id: 1).to_id }

    it { expect(subject).to eq 1 }
  end

  describe '#lock_in_share!' do
    subject { Item.find_by(id: 1).lock_in_share! }

    before do
      ApplicationRecord.transaction do
        Item.create!(id: 1, field1: 'item1')
      end
    end

    it do
      expect(subject.id).to eq 1
    end
  end
end
