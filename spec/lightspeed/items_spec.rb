require 'spec_helper'

describe Lightspeed::Items do
  setup_client_and_account

  it "can fetch items" do
    VCR.use_cassette("account/items/index") do
      items = account.items.all
      expect(items).to be_an(Array)
      expect(items.count).to eq(7)

      item = items.first
      expect(item).to be_a(Lightspeed::Item)
      expect(item.id).to eq("2")
    end
  end

  it "can fetch items where itemMatrixID is 0" do
    VCR.use_cassette("account/items/index_without_item_matrices") do
      items = account.items.all(params: { itemMatrixID: 0 })
      expect(items).to be_an(Array)
      expect(items.count).to eq(3)

      item = items.first
      expect(item).to be_a(Lightspeed::Item)
      expect(item.id).to eq("6")
      expect(item.item_matrix).to be_nil
    end
  end

  it "can fetch an item by ID" do
    VCR.use_cassette("account/items/show") do
      item = account.items.find(2)
      expect(item).to be_a(Lightspeed::Item)
    end
  end

  context "creating" do
    it "with valid information" do
      VCR.use_cassette("account/items/create") do
        item = account.items.create(description: "Onesie")
        expect(item).to be_a(Lightspeed::Item)
        expect(item.id).not_to be_nil
      end
    end

    it "missing a description" do
      VCR.use_cassette("account/items/create_invalid") do
        expect do
          account.items.create(description: "")
        end.to raise_error(Lightspeed::Errors::BadRequest, "Item not created. An Item must have a description.")
      end
    end
  end

  context "updating" do
    it "with valid information" do
      VCR.use_cassette("account/items/update") do
        item = account.items.update(2, description: "T-Shirt Red Small")

        expect(item.description).to eq("T-Shirt Red Small")
      end
    end

    it "missing a description" do
      VCR.use_cassette("account/items/update_invalid") do
        expect do
          account.items.update(2, description: "")
        end.to raise_error(Lightspeed::Errors::BadRequest, "Item not updated. An Item must have a description.")
      end
    end
  end

  it "can archive an item" do
    VCR.use_cassette("account/items/archive") do
      item = account.items.archive(2)
      expect(item.archived).to eq("true")
    end
  end
end
