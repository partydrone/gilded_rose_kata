require 'minitest/autorun'
require './lib/gilded_rose'

describe "#update_quality" do
  describe "with a single" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 10 }
    let(:item) { Item.new(item_name, initial_sell_in, initial_quality) }

    before do
      update_quality [item]
    end

    describe "normal item" do
      let(:item_name) { "NORMAL ITEM" }

      before do
        item.sell_in.must_equal initial_sell_in - 1
      end

      describe "before sell date" do
        specify { item.quality.must_equal initial_quality - 1 }
      end

      describe "on sell date" do
        let(:initial_sell_in) { 0 }
        specify { item.quality.must_equal initial_quality - 2 }
      end

      describe "after sell date" do
        let(:initial_sell_in) { -10 }
        specify { item.quality.must_equal initial_quality - 2 }
      end

      describe "of zero quality" do
        let(:initial_quality) { 0 }
        specify { item.quality.must_equal 0 }
      end
    end

    describe "Aged Brie" do
      let(:item_name) { "Aged Brie" }

      before do
        item.sell_in.must_equal initial_sell_in - 1
      end

      describe "before sell date" do
        specify { item.quality.must_equal initial_quality + 1 }

        describe "with max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "on sell date" do
        let(:initial_sell_in) { 0 }
        specify { item.quality.must_equal initial_quality + 2 }

        describe "near max quality" do
          let(:initial_quality) { 49 }
          specify { item.quality.must_equal 50 }
        end

        describe "with max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "after sell date" do
        let(:initial_sell_in) { -10 }
        specify { item.quality.must_equal initial_quality + 2 }

        describe "with max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end
    end

    describe "Sulfuras" do
      let(:initial_quality) { 80 }
      let(:item_name) { "Sulfuras, Hand of Ragnaros" }

      before do
        item.sell_in.must_equal initial_sell_in
      end

      describe "before sell date" do
        specify { item.quality.must_equal initial_quality }
      end

      describe "on sell date" do
        let(:initial_sell_in) { 0 }
        specify { item.quality.must_equal initial_quality }
      end

      describe "after sell date" do
        let(:initial_sell_in) { -10 }
        specify { item.quality.must_equal initial_quality }
      end
    end

    describe "Backstage pass" do
      let(:item_name) { "Backstage passes to a TAFKAL80ETC concert" }

      before do
        item.sell_in.must_equal initial_sell_in - 1
      end

      describe "long before sell date" do
        let(:initial_sell_in) { 11 }
        specify { item.quality.must_equal initial_quality + 1 }

        describe "at max quality" do
          let(:initial_quality) { 50 }
        end
      end

      describe "medium close to sell date (upper bound)" do
        let(:initial_sell_in) { 10 }
        specify { item.quality.must_equal initial_quality + 2 }

        describe "at max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "medium close to sell date (lower bound)" do
        let(:initial_sell_in) { 6 }
        specify { item.quality.must_equal initial_quality + 2 }

        describe "at max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "very close to sell date (upper bound)" do
        let(:initial_sell_in) { 5 }
        specify { item.quality.must_equal initial_quality + 3 }

        describe "at max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "very close to sell date (lower bound)" do
        let(:initial_sell_in) { 1 }
        specify { item.quality.must_equal initial_quality + 3 }

        describe "at max quality" do
          let(:initial_quality) { 50 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "on sell date" do
        let(:initial_sell_in) { 0 }
        specify { item.quality.must_equal 0 }
      end

      describe "after sell date" do
        let(:initial_sell_in) { -10 }
        specify { item.quality.must_equal 0 }
      end
    end

    describe "conjured item" do
      let(:item_name) { "Conjured Mana Cake" }

      before do
        skip
        item.sell_in.must_equal initial_sell_in - 1
      end

      describe "before sell date" do
        let(:initial_sell_in) { 5 }
        specify { item.quality.must_equal initial_quality - 2 }

        describe "at zero quality" do
          let(:initial_quality) { 0 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "on sell date" do
        let(:initial_sell_in) { 0 }
        specify { item.quality.must_equal initial_quality - 4 }

        describe "at zero quality" do
          let(:initial_quality) { 0 }
          specify { item.quality.must_equal initial_quality }
        end
      end

      describe "after sell date" do
        let(:initial_sell_in) { -10 }
        specify { item.quality.must_equal initial_quality - 4 }

        describe "at zero quality" do
          let(:initial_quality) { 0 }
          specify { item.quality.must_equal initial_quality }
        end
      end
    end
  end

  describe "with several objects" do
    let(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10)
      ]
    }

    before do
      update_quality(items)
    end

    specify { items[0].quality.must_equal 9 }
    specify { items[0].sell_in.must_equal 4 }

    specify { items[1].quality.must_equal 11 }
    specify { items[1].sell_in.must_equal 2 }
  end
end
